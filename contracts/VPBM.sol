/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title VPBM - Validate Proof Before Mint
/// @notice Validate Merkle Proof for NFgenes List before minting
/// @author The team at NFgenes https://github.com/orgs/nfgenes/people

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

/// @custom:security-contact nfgenes@protonmail.com
contract VPBM is Ownable {
    bytes32 public rootHash;

    /// @param _rootHash current Merkle Tree root hash
    constructor(bytes32 _rootHash) {
        rootHash = _rootHash;
    }

    /// @notice Mapping to track when a gene has been minted
    mapping(bytes32 => bool) public geneMinted;

    function modifyRootHash(bytes32 _rootHash) public onlyOwner {
        rootHash = _rootHash;
    }
    
    /// @notice submit a proof for verfication using params(_leaf, _proof)
    /// @param _leaf the value that is being validated
    /// @param _proof the set of hashes used to validate the given leaf
    /// @return bool
    function verifyProof(
        bytes32 _leaf,
        bytes32[] calldata _proof
        ) public virtual returns (bool) {
            require(!geneMinted[_leaf], "Gene has already been minted");
            require(MerkleProof.verify(_proof, rootHash, _leaf), "Invalid Proof");
            return true;
    }
}

