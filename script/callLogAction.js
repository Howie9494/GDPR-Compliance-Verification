const Web3 = require('web3');
const path = require('path');
const fs = require('fs-extra');
//const EthCrypto = require('eth-crypto');

const contractPath = path.resolve(__dirname,'../build','contracts_LogContract_sol_LogContract.abi');
const abi = fs.readJsonSync(contractPath,'utf-8');
// // Replace with your Goerli Infura endpoint
const web3 = new Web3('https://goerli.infura.io/v3/8ace39a5a8ab475eb44a15774dc5a293');

// // Replace with your deployed contract address
const logContractAddressPath = path.resolve(__dirname,'../build','LogContract.txt');
const contractAddress = fs.readFileSync(logContractAddressPath,'utf-8');

const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';

// // Replace with your account private key (remove the leading 0x)
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';

// // Create a contract instance
const logContract = new web3.eth.Contract(abi, contractAddress);

async function logAction(contractId) {
    const actorId = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
    const operation = 1; // Assuming 'read' is 1 in the enum
    const processedData = ['gyj', 'test'];
    const serviceName = '111';

    //const publicKey = EthCrypto.publicKeyByPrivateKey(privateKey);
    //const encryptedProcessedData = await encryptData(processedData, publicKey);
    const logActionFunction = logContract.methods.logAction(actorId, operation, processedData,serviceName,contractId);
    const gas = await logActionFunction.estimateGas({ from: account });
    const data = logActionFunction.encodeABI();
    const nonce = await web3.eth.getTransactionCount(account);

    const signedTransaction = await web3.eth.accounts.signTransaction({
        to: contractAddress,
        data: data,
        gas: gas,
        nonce: nonce,
        chainId: 5 
    }, privateKey);

    const transactionReceipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);
    console.log('Transaction receipt:', transactionReceipt);
}

// async function encryptData(personalDataList, publicKey) {
//     const encryptedDataList = [];
  
//     for (const data of personalDataList) {
//       const encryptedData = await EthCrypto.encryptWithPublicKey(publicKey, data);
//       encryptedDataList.push(EthCrypto.cipher.stringify(encryptedData));
//     }
  
//     return encryptedDataList;
// }

var arguments = process.argv.slice(2);
if(!arguments[0]){
    console.log('contractId must be entered');
    return;
}
logAction(arguments[0]);
