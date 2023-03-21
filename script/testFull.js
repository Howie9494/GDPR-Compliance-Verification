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

// // Replace with your account private key (remove the leading 0x)
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';

// // Create a contract instance
const dataUsageContract = new web3.eth.Contract(abi, contractAddress);

async function addPurpose() {
    const serviceName = 'CSC82233';
    const servicePurpose = 'read';
    const operation = 2; // Assuming 'read' is 1 in the enum
    const personalDataList = ['gyj', 'test'];
    const dataOwner = '0x910DFBB7e9298Df687827561453342Cb8781C03C';

    const addPurposeFunction = dataUsageContract.methods.addPurpose(dataOwner,serviceName, servicePurpose, operation, personalDataList);
    const gas = await addPurposeFunction.estimateGas({ from: account });
    const data = addPurposeFunction.encodeABI();
    const nonce = await web3.eth.getTransactionCount(account);

    const signedTransaction = await web3.eth.accounts.signTransaction({
        to: contractAddress,
        data: data,
        gas: gas,
        nonce: nonce,
        chainId: 5 
    }, privateKey);

    const transactionReceipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);

    addPurposeFunction.call({from:account},function(err,res){
        console.log(res);
        vote(res);
        //logAction(res);
    })
    // console.log('Transaction receipt:', transactionReceipt);
}

addPurpose();


const agreementContractPath = path.resolve(__dirname,'../build','contracts_AgreementContract_sol_AgreementContract.abi');
const agreementAbi = fs.readJsonSync(agreementContractPath,'utf-8');

const agreementContractAddressPath = path.resolve(__dirname,'../build','AgreementContract.txt');
const agreementContractAddress = fs.readFileSync(agreementContractAddressPath,'utf-8');

// // Create a contract instance
const agreementContract = new web3.eth.Contract(agreementAbi, agreementContractAddress);

async function vote(contractId) {
    console.log('vote begin');
    const hashAddress = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
    const actorAddress = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
    const userConsent = true;

    const voteFunction = agreementContract.methods.vote(contractId,hashAddress,actorAddress,userConsent);
    const gas = await voteFunction.estimateGas({ from: account });
    const data = voteFunction.encodeABI();
    const nonce = await web3.eth.getTransactionCount(account);

    const signedTransaction = await web3.eth.accounts.signTransaction({
        to: agreementContractAddress,
        data: data,
        gas: gas,
        nonce: nonce,
        chainId: 5 
    }, privateKey);

    const transactionReceipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);
    console.log('vote complete');
    //console.log('Transaction receipt:', transactionReceipt);
    logAction(contractId);
}

const logContractPath = path.resolve(__dirname,'../build','contracts_LogContract_sol_LogContract.abi');
const logAbi = fs.readJsonSync(logContractPath,'utf-8');
// // Replace with your Goerli Infura endpoint

// // Replace with your deployed contract address
const logContractAddressPath = path.resolve(__dirname,'../build','LogContract.txt');
const logContractAddress = fs.readFileSync(logContractAddressPath,'utf-8');

// // Create a contract instance
const logContract = new web3.eth.Contract(logAbi, logContractAddress);

async function logAction(contractId) {
    console.log('logAction begin');
    const actorId = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
    const operation = 2; // Assuming 'read' is 1 in the enum
    const processedData = ['gyj', 'test'];
    const serviceName = '111';

    const logActionFunction = logContract.methods.logAction(actorId, operation, processedData,serviceName,contractId);
    const gas = await logActionFunction.estimateGas({ from: account });
    const data = logActionFunction.encodeABI();
    const nonce = await web3.eth.getTransactionCount(account);

    const signedTransaction = await web3.eth.accounts.signTransaction({
        to: logContractAddress,
        data: data,
        gas: gas,
        nonce: nonce,
        chainId: 5 
    }, privateKey);

    const transactionReceipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);
    console.log('log complete');
    //console.log('Transaction receipt:', transactionReceipt);
}
