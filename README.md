# NFgenes Minting Contracts

## VPBM - Validate Proof Before Mint Contract

This contract is used to validate the NFgenes List that is stored immutably on IPFS [here](https://github.com/nfgenes/nfgenes_list/tree/main/data#current-list-on-ipfs).

The NFgenes list is not expected to change, however, to accomodate the nature of scientific research, we want to allow the ability to update the list if new research requires it. A change to the list will be approved by the NFgene DAO before the new list is published to IPFS.

In order for the minting contract to allow minting of only those genes listed on the NFgenes list, a Merkle Tree has been generated of the entire list. The Merkle root hash is stored in the VPBM contract as a state variable. Before a new gene is minted, a Merkle Proof must be provided to the contract. The contract will validate the proof and return 'true/false' depending on whether the request gene is on the list.

## NFgene Minting Contract

Learn more about the [NFgenes 🧬⛓ project](https://github.com/nfgenes/overview#nfgenes-nonfungible-genes-overview)
