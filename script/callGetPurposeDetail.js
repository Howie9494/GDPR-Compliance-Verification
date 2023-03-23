const Web3 = require('web3');
const path = require('path');
const fs = require('fs-extra');

const contractPath = path.resolve(__dirname,'../build','contracts_DataUsageContract_sol_DataUsageContract.abi');
const abi = fs.readJsonSync(contractPath,'utf-8');
// // Replace with your Goerli Infura endpoint
const web3 = new Web3('https://goerli.infura.io/v3/8ace39a5a8ab475eb44a15774dc5a293');

const dataUsageContractAddressPath = path.resolve(__dirname,'../build','DataUsageContract.txt');
const contractAddress = fs.readFileSync(dataUsageContractAddressPath,'utf-8');

const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';

// // Create a contract instance
const dataUsageContract = new web3.eth.Contract(abi, contractAddress);

async function getPurposeDetail(contractId) {
    console.log(contractId);

    const getPurposeDetailFunction = dataUsageContract.methods.getPurposeDetail(contractId);
    // const gas = await addPurposeFunction.estimateGas({ from: account });
    // const data = addPurposeFunction.encodeABI();
    // const nonce = await web3.eth.getTransactionCount(account);

    // const signedTransaction = await web3.eth.accounts.signTransaction({
    //     to: contractAddress,
    //     data: data,
    //     gas: gas,
    //     nonce: nonce,
    //     chainId: 5 
    // }, privateKey);

    // const transactionReceipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);

    getPurposeDetailFunction.call({from:account},function(err,res){
        console.log(res);
    })
}

var arguments = process.argv.slice(2);
if(!arguments[0]){
    console.log('contractId must be entered');
    return;
}
getPurposeDetail(arguments[0]);