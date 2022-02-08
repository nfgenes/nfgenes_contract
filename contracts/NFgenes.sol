// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title NFgenes - Share knowledge, create value, build a community and teach science
/// @notice Mint an NFT representing one of ~40k unique human genes.
/// @author The team at the NFgenes Project https://github.com/orgs/nfgenes/people

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./VPBM.sol";

/// @custom:security-contact nfgenes@protonmail.com
contract NFgenes is
    ERC721,
    ERC721URIStorage,
    Ownable,
    VPBM
{
    /// remove this strings declaration, was just using for testing purposes <======================================================
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private tokenIdCounter;

    /// @notice base IPFS CID containing the set of all NFgenes
    string public baseURI = "";

    /// @dev maintain a count for number of NFgenes currently minted
    uint public currentMintCount;

    /// @notice mapping of gene symbols (stored as bytes32) to addresses
    mapping(bytes32 => address) public owners;

    // mapping(string => string) geneSymbolToName;
    // mapping(string => string) geneSymbolToLength;
    // mapping(string => string) geneSymbolToLocalization1;
    // mapping(string => string) geneSymbolToLocalization2;

    /// @param _initialBaseURI set an IPFS CID for the initial list of NFgenes
    /// @param _rootHash initial Merkle Tree root hash
    constructor(string memory _initialBaseURI, bytes32 _rootHash)
        ERC721("NFgenes", "GENE")
        VPBM(_rootHash) {
        // @dev set initial base URI
        baseURI = _initialBaseURI;
    }

    // function generateTokenMetadata() public onlyOwner returns (string memory) {
    
    // }

    /// @dev All NFgenes data will be stored on IPFS, but the CID could possibly change,
    /// so while an initial baseURI will be set in the constructor, if a new list of genes
    /// is published to IPFS, then the 'setBaseURI' method will be called to update it
    /// @param _newBaseURI the new IPFS CID for the root folder containing all NFgenes
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function getBaseURI() public view returns (string memory) {
        return baseURI;
    }

    /// @dev only allow the contract owner to burn a token
    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) onlyOwner {
        super._burn(_tokenId);
    }

    /// @dev override to allow changing the baseURI inherited from ERC721.sol
    /// @return the string value of the baseURI (IPFS CID Hash)
    function _baseURI() internal view override(ERC721) returns (string memory) {
        return baseURI;
    } 

    // @param _tokenId the gene symbol
    function tokenURI(bytes32 _tokenId) public view override returns (bytes32) {
        require(_exists(_tokenId), "Token does not exist");

        string memory tokenId = string(abi.encodePacked(baseURI, _tokenId));

        return tokenId;
    }

    function _exists(bytes32 tokenId) internal view override returns (bool) {
        return owners[tokenId] != address(0);
    }

    // function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
    //     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    //     return tokenId.toString();
    // }
}