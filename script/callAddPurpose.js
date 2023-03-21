const Web3 = require('web3');
const path = require('path');
const fs = require('fs-extra');
const contractPath = path.resolve(__dirname,'../build','contracts_DataUsageContract_sol_DataUsageContract.abi');
const abi = fs.readJsonSync(contractPath,'utf-8');
// // Replace with your Goerli Infura endpoint
const web3 = new Web3('https://goerli.infura.io/v3/8ace39a5a8ab475eb44a15774dc5a293');

// // Replace with your deployed contract address
const contractAddress = '0x31d5b3009ff553909f1bc9fa5cb9a5e2ef2c367a';

const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';

// // Replace with your account private key (remove the leading 0x)
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';

// // Create a contract instance
const dataUsageContract = new web3.eth.Contract(abi, contractAddress);

async function addPurpose() {
    const serviceName = 'CSC8113';
    const servicePurpose = 'read';
    const operation = 1; // Assuming 'read' is 1 in the enum
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
    })
    // console.log('Transaction receipt:', transactionReceipt);
}

addPurpose();


const agreementContractPath = path.resolve(__dirname,'../build','contracts_AgreementContract_sol_AgreementContract.abi');
const agreementAbi = fs.readJsonSync(agreementContractPath,'utf-8');

const agreementContractAddressPath = path.resolve(__dirname,'../build','VerificationContract.txt');
const agreementContractAddress = fs.readFileSync(agreementContractAddressPath,'utf-8');

// // Create a contract instance
const agreementContract = new web3.eth.Contract(agreementAbi, agreementContractAddress);

async function vote(contractId) {
    console.log(contractId);
    const hashAddress = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
    const actorAddress = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
    const userConsent = true;

    const voteFunction = agreementContract.methods.vote(contractId,hashAddress,actorAddress,userConsent);
    // const gas = await voteFunction.estimateGas({ from: account });
    // const data = voteFunction.encodeABI();
    // const nonce = await web3.eth.getTransactionCount(account);

    // const signedTransaction = await web3.eth.accounts.signTransaction({
    //     to: contractAddress,
    //     data: data,
    //     gas: gas,
    //     nonce: nonce,
    //     chainId: 5 
    // }, privateKey);

    // const transactionReceipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);

    voteFunction.call({from:account},function(err,res){
        if(!err){
            console.log(res)
        }else{
            console.log(err);
        }
    })
    // console.log('Transaction receipt:', transactionReceipt);
}
