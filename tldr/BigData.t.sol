// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "forge-std/Test.sol";
import "../src/BigData.sol";

/*
The top 5 addresses below are from the Hardhat project. The Merkle tree inputs for both contracts and tests suites should be the exact same.
[
  '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266', // admin
  '0x70997970C51812dc3A010C7d01b50e0d17dc79C8', // user
  '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC', // signer
  '0x90F79bf6EB2c4f870365E785982E1f101E93b906', // userTwo
  '0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65' // userThree
  '0xe05fcC23807536bEe418f142D19fa0d21BB0cfF7' // userPrivateKey below
]
*/

contract BigDataTest is Test {
    using ECDSA for bytes32;

    BigData public bigdata;

    uint256 internal userPrivateKey;
    uint256 internal signerPrivateKey;

    function setUp() public {
        bigdata = new BigData();

        userPrivateKey = 0xa11ce;
        signerPrivateKey = 0xabc123;

        address signer = vm.addr(signerPrivateKey);
        bigdata.setSystemAddress(signer);

        // Same as the Merkle root in the Hardhat project, again not working yet
        bigdata.setMerkleRoot(0x04e2e33f1fa42038cccf7dcdf090b24bf914dabe5367ca840e17ad92c6316bf5);
    }

    function testPurchase() public {
        address user = vm.addr(userPrivateKey);
        address signer = vm.addr(signerPrivateKey);

        uint256 amount = 2;
        string memory nonce = 'QSfd8gQE4WYzO29';

        vm.startPrank(signer);
        bytes32 digest = keccak256(abi.encodePacked(user, amount, nonce)).toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.stopPrank();

        // This data/format isn't correct somehow. Works in Hardhat, not yet in Foundry
        // Proof is ignored for now in the contract
        bytes32[] memory proof = new bytes32[](3);
        proof[0] = bytes32(0xe9707d0e6171f728f7473c24cc0432a9b07eaaf1efed6a137a4a8c12c79552d9);
        proof[1] = bytes32(0x7e0eefeb2d8740528b8f598997a219669f0842302d3c573e9bb7262be3387e63);
        proof[2] = bytes32(0x08af4f60478eb4b86385d9b38e8fa9d3dd996b6128ab7f0f8bb548902dc6f7bc);

        vm.startPrank(user);

        bytes memory data = abi.encode(user, uint256(5)); // can mint up to 5

        // Give the user some ETH, just for good measure
        vm.deal(user, 1 ether);

        bigdata.purchase(
            amount,
            signature,
            data,
            proof,
            nonce
        );

        vm.stopPrank();
    }
}
