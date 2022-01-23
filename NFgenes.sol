// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title NFgenes - Share knowledge, create value, build a community and teach science
/// @notice Mint an NFT representing one of ~20k unique human genes.

// import "hardhat/consol.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/// @custom:security-contact nfgenes@protonmail.com
contract NFgenesTest is
    Ownable,
    ERC721,
    ERC721URIStorage
{
    using Counters for Counters.Counter;
    Counters.Counter private tokenIdCounter;

    string baseURI = '';
    // mapping(string => string) geneSymbolToName;
    // mapping(string => string) geneSymbolToLength;
    // mapping(string => string) geneSymbolToLocalization1;
    // mapping(string => string) geneSymbolToLocalization2;

    constructor(string memory _initialBaseURI) ERC721("NFgenes", "GENE") {
        // @dev increment _tokenIds to begin at 1 instead of 0
        tokenIdCounter.increment();

        // @dev set initial base URI
        baseURI = _initialBaseURI;
    }

    // function generateTokenMetadata() public onlyOwner returns (string memory) {
    
    // }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function getBaseURI() public returns (string memory) {
        return baseURI;
    }

    /*
     *  @dev override the following functions, as required by solidity
     *  https://docs.soliditylang.org/en/v0.8.11/contracts.html?highlight=override#function-overriding
    */
    // @dev only allow the contract owner to burn a token
    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) onlyOwner {
        super._burn(_tokenId);
    }

    // @dev override to allow changing the base URI
    function _baseURI() internal view override(ERC721) returns (string memory) {
        return baseURI;
    } 

    function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    }
}