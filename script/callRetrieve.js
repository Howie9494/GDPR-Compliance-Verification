const Web3 = require('web3');
const path = require('path');
const fs = require('fs-extra');
//const EthCrypto = require('eth-crypto');

const web3 = new Web3('https://goerli.infura.io/v3/8ace39a5a8ab475eb44a15774dc5a293');
const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';

const agreementContractPath = path.resolve(__dirname,'../build','contracts_AgreementContract_sol_AgreementContract.abi');
const agreementAbi = fs.readJsonSync(agreementContractPath,'utf-8');

const agreementContractAddressPath = path.resolve(__dirname,'../build','AgreementContract.txt');
const agreementContractAddress = fs.readFileSync(agreementContractAddressPath,'utf-8');

// // Create a contract instance
const agreementContract = new web3.eth.Contract(agreementAbi, agreementContractAddress);

async function retrieve(contractId) {

    const retrieveFunction = agreementContract.methods.retrieve(contractId);
    // const gas = await retrieveFunction.estimateGas({ from: account });
    // const data = retrieveFunction.encodeABI();
    // const nonce = await web3.eth.getTransactionCount(account);

    // const signedTransaction = await web3.eth.accounts.signTransaction({
    //     to: agreementContractAddress,
    //     data: data,
    //     gas: gas,
    //     nonce: nonce,
    //     chainId: 5 
    // }, privateKey);

    // const transactionReceipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);

    retrieveFunction.call({from:account},function(err,res){
        if(!err){
            console.log(res);
            // const decryptedDataList = await decryptData(res['personalDataList'],privateKey);
            // console.log("The decrypted personalDataList is:",decryptedDataList);
        }else{
            console.log(err);
        }
    })
    // console.log('Transaction receipt:', transactionReceipt);
}

// async function decryptData(encryptedDataList, privateKey) {
//     const decryptedDataList = [];
  
//     for (const encryptedDataString of encryptedDataList) {
//       const encryptedData = EthCrypto.cipher.parse(encryptedDataString);
//       const decryptedData = await EthCrypto.decryptWithPrivateKey(privateKey, encryptedData);
//       decryptedDataList.push(decryptedData);
//     }
  
//     return decryptedDataList;
// }

var arguments = process.argv.slice(2);
if(!arguments[0]){
    console.log('contractId must be entered');
    return;
}
retrieve(arguments[0]);
