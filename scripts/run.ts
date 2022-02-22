const { ethers } = require("ethers");
const hre = require("hardhat");

async function Main() {
    const contractFactory = await hre.ethers.getContractFactory('NFgenes');
    const contract = await contractFactory.deploy("initialBaseURI", "0x9999999999999999999999999999999999999999999999999999999999999999");

    await contract.deployed();
    console.log("NFgenes Contract has been deployed to ", contract.address);

    let txn;

    // Get current baseURI
    txn = await contract.getBaseURI();
    console.log(`Current baseURI: ${txn}`);
    
    // check if we can change the baseURI
    console.log("Changing the baseURI...");
    txn = await contract.setBaseURI("newBaseURI");
    console.log(`baseURI has been changed successfully`);

    // Get new baseURI
    txn = await contract.getBaseURI();
    console.log(`Current baseURI: ${txn}`);

    // Get the current root hash
    txn = await contract.rootHash();
    console.log(`Current root hash: ${txn}`);

    // Change the root hash
    txn = await contract.modifyRootHash("0xa0465a851f47a19d205eaed67def592d651475fd2204f59d72e9e39482d86736");
    console.log(`Root has been changed successfully`);
   // Get the new root hash
   txn = await contract.rootHash();
   console.log(`New root hash is ${txn}`);
    
   // attempt to mint a valid gene with provided leaf hash and corresponding proof
   let value = "0x2EF9A043955f934c93632C9E45BA739e5468DA6d"

   // check if value is already minted
   txn = await contract.geneMinted("0x65e76fcc6f5e02b785a4638d0e6e11260b0479477ff966037c7b6410da14ec22");
   console.log(`Gene Minted?: ${txn}`);
   
   // mintGene params: bytes32 _leafHash, bytes32[] calldata _proof, bytes memory _leafValue
   txn = await contract.mintGene("0x65e76fcc6f5e02b785a4638d0e6e11260b0479477ff966037c7b6410da14ec22", [
    "0x824fe4d63410846552b59181adc9ee0a427efd7ae3e34f1a57bd42e224172562",
    "0xc6c50f6da05fe9aa90a614fa79f6da1de9406ddcf4b1103bc72a2928e23989e9",
    "0x44e5ac0ad3354b384398290866dc6b560aba6ccfc7ec5881df56a693012eec11",
    "0x2885b3b387fa83132c889dff1497c24214d0db3a81015f7a50408809f16c399c"
    ], value);

    txn.wait();
 
    // log out token id and mappings
    let mintCount = await contract.currentMintCount();
    console.log(`Current Mint Count: ${mintCount}`);
    
    txn = await contract.getTokenIdToOwner(mintCount);
    console.log(`Token Id #1 Owner: ${txn}`);

    let symbol = await contract.getTokenIdToSymbol(mintCount);
    txn = await contract.getTokenIdToSymbol(mintCount);
    console.log(`Token Id #1 Symbol: ${symbol}`);

    txn = await contract.getSymbolToTokenId(symbol);
    console.log(`Symbol ${symbol} token id: ${mintCount}`);

    // check if value is already minted
   txn = await contract.geneMinted("0x65e76fcc6f5e02b785a4638d0e6e11260b0479477ff966037c7b6410da14ec22");
   console.log(`Gene Minted?: ${txn}`);
}

async function runMain() {
    try {
        await Main();
        process.exit(0);
    } catch (e) {
        console.log(e);
        process.exit(1);
    }
}

runMain();