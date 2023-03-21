const Web3 = require('web3');
const path = require('path');
const fs = require('fs-extra');
const EthCrypto = require('eth-crypto');

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

    const publicKey = EthCrypto.publicKeyByPrivateKey(privateKey);
    const encryptedDataList = await encryptData(personalDataList, publicKey);
    const addPurposeFunction = dataUsageContract.methods.addPurpose(dataOwner,serviceName, servicePurpose, operation, encryptedDataList);
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
    })
    // console.log('Transaction receipt:', transactionReceipt);
}

async function encryptData(personalDataList, publicKey) {
    const encryptedDataList = [];
  
    for (const data of personalDataList) {
      const encryptedData = await EthCrypto.encryptWithPublicKey(publicKey, data);
      encryptedDataList.push(EthCrypto.cipher.stringify(encryptedData));
    }
  
    return encryptedDataList;
}

addPurpose();