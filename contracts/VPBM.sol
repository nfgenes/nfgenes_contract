/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title VPBM - Validate Proof Before Mint
/// @notice Validate Merkle Proof for NFgenes List before minting
/// @author The team at NFgenes https://github.com/orgs/nfgenes/people

/*
 *  Import OpenZeppelin Merkle Tree Contract
 *  https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
*/
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

/// @custom:security-contact nfgenes@protonmail.com
contract VPBM is Ownable {
    /// @notice The NGgenes list is stored immutably on IPFS. A Merkle Tree is generated from that list and the
    /// root hash is stored below. If the NFgene DAO updates the NFgenes list, a new list will be published to
    /// IPFS and the corresponding root hash below will be replaced.
    bytes32 public rootHash;

    /// @notice Mapping to track when a gene has been minted
    mapping(bytes32 => bool) public geneMinted;

    constructor(bytes32 _rootHash) {
        rootHash = _rootHash;
    }

    function mintGene(bytes32 _leaf, bytes32[] calldata _proof) public virtual returns (bool) {
        require(!geneMinted[_leaf], "This gene has already been minted");
        require(MerkleProof.verify(_proof, rootHash, _leaf), "Invalid Proof");
        geneMinted[_leaf] = true;
        return true;
    }

    function modifyRootHash(bytes32 _rootHash) public onlyOwner {
        rootHash = _rootHash;
    }
}