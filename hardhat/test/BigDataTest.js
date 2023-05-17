const { expect } = require("chai")
const { ethers } = require("hardhat")
const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')

var randomString = function (length) {
  var text = '';
  var possible =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  for (var i = 0; i < length; i++) {
    text += possible.charAt(Math.floor(Math.random() * possible.length));
  }
  return text;
};

// Encode the data of their address and the max amount they can mint
const encodeData = (data) => {
  const encoder = new ethers.utils.AbiCoder
  return encoder.encode(
    ['address', 'uint256'],
    [data[0], data[1]]
  )
}

// Generate a signature
const generateSignature = async (signer, address, amount, nonce) => {
  const messageHash = ethers.utils.solidityKeccak256(
    ['address', 'uint256', 'string'],
    [address, amount, nonce]
  )
  const messageHashBinary = ethers.utils.arrayify(messageHash)
  return await signer.signMessage(messageHashBinary)
}

/*//////////////////////////////////////////////////////////////
                            THE TESTS
//////////////////////////////////////////////////////////////*/

describe("BigDataTest", function () {
  before(async function () {
    this.Contract = await ethers.getContractFactory("BigData");
    this.MinterFilter = await ethers.getContractFactory('BigData')
  });

  beforeEach(async function () {
    contract = await this.Contract.deploy()
    await contract.deployed();
    this.contract = await ethers.getContractAt("BigData", contract.address)

    const [admin, user, signer, userTwo, userThree] = await ethers.getSigners();

    var c = contract.connect(admin)

    // The private key for this address will do the signing on your backend
    await c.setSystemAddress(signer.address)

    // Addresses for the allowlist
    const addresses = [
      admin.address,
      user.address,
      signer.address,
      userTwo.address,
      userThree.address,
      '0xe05fcC23807536bEe418f142D19fa0d21BB0cfF7'
    ]

    const leaves = addresses.map((address) =>
      ethers.utils.solidityKeccak256(
        ['address'],
        [ethers.utils.getAddress(address)]
      )
    )

    const merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true })
    const root = merkleTree.getRoot().toString('hex')
    // console.log('root: 0x' + root)

    await c.setMerkleRoot(`0x${root}`)
  })

  describe("Call the contract", async () => {
    it("should work", async () => {
      const [admin, user, signer, userTwo, userThree] = await ethers.getSigners();

      const addresses = [
        admin.address,
        user.address,
        signer.address,
        userTwo.address,
        userThree.address,
        '0xe05fcC23807536bEe418f142D19fa0d21BB0cfF7', // The address generated in our Foundry setup
      ]

      const leaves = addresses.map((address) =>
        ethers.utils.solidityKeccak256(
          ['address'],
          [ethers.utils.getAddress(address)]
        )
      )

      const merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true })

      var c = contract.connect(user)

      const amount = 2
      const nonce = randomString(15)

      // Signs a message with the private key of impersonatedSigner. It signs the user's address, the amount they're minting, and a random string
      const signature = await generateSignature(signer, user.address, amount, nonce)

      // Encodes the user's address and the max amount they can mint for decoding in the contract
      const data = encodeData([user.address, 5])

      const leaf = ethers.utils.solidityKeccak256(
        ['address'],
        [ethers.utils.getAddress(user.address)]
      )

      const merkleProof = merkleTree.getHexProof(leaf)
      // console.log('proof', merkleProof)

      // Do the purchase, expect no revert
      await expect(
        c.purchase(
          amount,
          signature,
          data,
          merkleProof,
          nonce
        )
      ).to.not.be.reverted
    })
  })
})
