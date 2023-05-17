// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/*
    This is the same as the BigData.sol contract in the Hardhat directory but with the Merkle tree verification stuff temporarily commented out
*/

contract BigData is Ownable {
    using MerkleProof for bytes32[];
    using ECDSA for bytes32;

    address public systemAddress;

    bytes32 public merkleRoot;

    function purchase(
        uint256 _amount,
        bytes calldata _signature,
        bytes calldata _data,
        bytes32[] calldata _merkleProof,
        string calldata _nonce
    ) external {
        require(systemAddress != address(0), "Need system address");
        require(merkleRoot != bytes32(0), "Need merkle root");

        require(isValidSignature(
            systemAddress,
            keccak256(abi.encodePacked(msg.sender, _amount, _nonce)),
            _signature
            ), "Invalid Signature"
        );

        (address _address, uint256 maxMintCount) = abi.decode(_data, (address, uint256));
        require(_address == msg.sender, "Bad Data");
        require(_amount <= maxMintCount, "Can't mint that many");

        // Not currently working with the test input from Foundry
        // bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        // require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not On Allowlist");

        // Do the mint
    }

    function isValidSignature(
        address _systemAddress,
        bytes32 hash,
        bytes memory signature
    ) internal pure returns (bool) {
        require(_systemAddress != address(0), "Missing System Address");

        bytes32 signedHash = hash.toEthSignedMessageHash();
        return signedHash.recover(signature) == _systemAddress;
    }

    function setSystemAddress(address _address) external onlyOwner {
        systemAddress = _address;
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

}
