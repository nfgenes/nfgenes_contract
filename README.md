# NFgenes (NonFungible Genes) Overview

NFgenes is a decentralized science (DeSci) project aiming to bring data and collaboration for human genome research to the blockchain. Share knowledge, create value, build a community and teach science.

- [Roadmap](https://github.com/nfgenes/overview#roadmap)
- [NFgene List and Genesis Collection](https://github.com/nfgenes/nfgenes_list#nfgenes-nonfungible-genes-overview)
    - [NFgenes List](https://github.com/nfgenes/nfgenes_list/tree/main/data#nfgenes-list)
        - [Demo Proof of Concept: Storing NFgenes List on IPFS](https://nfgeneslist.onrender.com/)
        - [Repository](https://github.com/nfgenes/front_end_nfgenes_list#nfgenes-nonfungible-genes-overview)
    - [Genesis NFT Collection](https://github.com/nfgenes/nfgenes_contract)
- [Methodology for Compiling original list of NFgenes](https://github.com/nfgenes/compile_genesis_gene_list)
------------

# NFgenes Minting Contracts

## VPBM - Validate Proof Before Mint Contract

This contract is used to validate the NFgenes List that is stored immutably on IPFS [here](https://github.com/nfgenes/nfgenes_list/tree/main/data#current-list-on-ipfs).

The NFgenes list is not expected to change, however, to accomodate the nature of scientific research, we want to allow the ability to update the list if new research requires it. A change to the list will be approved by the NFgene DAO before the new list is published to IPFS.

In order for the minting contract to allow minting of only those genes listed on the NFgenes list, a Merkle Tree has been generated of the entire list. The Merkle root hash is stored in the VPBM contract as a state variable. Before a new gene is minted, a Merkle Proof must be provided to the contract. The contract will validate the proof and return 'true/false' depending on whether the request gene is on the list.

## NFgene Minting Contract

