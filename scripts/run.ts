const { ethers } = require("ethers");
const hre = require("hardhat");

async function Main() {
    const contractFactory = await hre.ethers.getContractFactory('NFgenes');
    const contract = await contractFactory.deploy("initialBaseURI", "0x8401dfe0636ed99359594620a57d8b3ac1249a1290f67977fc1cc81471b516ff");

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