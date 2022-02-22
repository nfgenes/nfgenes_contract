// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title NFgenes - Share knowledge, create value, build a community and teach science
/// @notice Mint an NFT representing one of ~20k unique human genes.
/// @author The team at the NFgenes Project https://github.com/orgs/nfgenes/people

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
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
    using Counters for Counters.Counter;
    Counters.Counter private tokenIdCounter;

    /// @dev maintain a count for number of NFgenes currently minted
    Counters.Counter public currentMintCount;

    /// @notice base IPFS CID containing the set of all NFgenes
    string public baseURI = "";

    /// @dev mapping of tokenIds to addresses
    mapping(uint256 => address) public tokenIdToOwner;

    /// @dev mapping of tokenIds to symbols
    mapping(uint256 => bytes32) public tokenIdToSymbol;

    /// @dev mapping of symbols to tokenIds
    mapping(bytes32 => uint256) public symbolToTokenId;

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

        /// @dev set initial tokenId to 1 instead of 0
        tokenIdCounter.increment();
    }

    /// @dev All NFgenes data will be stored on IPFS, but the CID could possibly change,
    /// so while an initial baseURI will be set in the constructor, if a new list of genes
    /// is published to IPFS, then the 'setBaseURI' method will be called to update it
    /// @notice Change the base URI, only the contract owner can do this
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

    /// @dev override to display the current baseURI
    /// @return the string value of the baseURI (IPFS CID Hash)
    function _baseURI() internal view override(ERC721) returns (string memory) {
        return baseURI;
    } 

    /// @param tokenId the gene symbol
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return super.tokenURI(tokenId);
    }

    function mintGene(bytes32 _leafHash, bytes32[] calldata _proof, bytes memory _leafValue) external {
        /// @dev get the current tokenId and assign to the new mint
        uint256 newTokenId = tokenIdCounter.current();
        console.log("Minting token #",newTokenId);

        /// @dev verify the symbol before allowing mint against a merkle proof
        bool geneVerified = verifyProof(_leafHash, _proof);

        geneVerified ? mint(newTokenId, geneVerified, _leafHash, _leafValue) : revert("invalid proof");
    }

    function mint(uint256 _newTokenId, bool _geneVerified, bytes32 _leafHash, bytes memory _leafValue) private {
        require(_geneVerified, "unable to mint");
        require(_leafHash == keccak256(_leafValue), "the values are not matching");

        /// @dev assign the new tokenId to the calling address
        console.log("Minting token for",msg.sender);
        _safeMint(msg.sender, _newTokenId);

        /// @dev increment the mint counter
        currentMintCount.increment();

        /// @dev assign mappings
        tokenIdToOwner[_newTokenId] = msg.sender;
        // tokenIdToSymbol[_newTokenId] = _leafValue;
        // symbolToTokenId[_leafValue] = _newTokenId;

        console.log("Token minted successfully");
    }

    function getTokenIdToOwner(uint256 _tokenId) public view returns (address) {
        return tokenIdToOwner[_tokenId];
    }

    function getTokenIdToSymbol(uint256 _tokenId) public view returns (bytes32) {
        return tokenIdToSymbol[_tokenId];
    }
}