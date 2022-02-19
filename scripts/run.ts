const { ethers } = require("ethers");
const hre = require("hardhat");

async function Main() {
    const contractFactory = await hre.ethers.getContractFactory('NFgenes');
    const contract = await contractFactory.deploy("initialBaseURI", "0x30e5855111ba1693c9e0f111119d66e61d759b5237245c3c5efb42c8839d146e");

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
    txn = await contract.modifyRootHash("0x30e5855111ba1693c9e0f036809d66e61d759b5237245c3c5efb42c8839d146e");
    console.log(`Root has been changed successfully`);
   // Get the new root hash
   txn = await contract.rootHash();
   console.log(`New root hash is ${txn}`);
    
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