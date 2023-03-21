const Web3 = require('web3');
const path = require('path');
const fs = require('fs-extra');

const web3 = new Web3('https://goerli.infura.io/v3/8ace39a5a8ab475eb44a15774dc5a293');
const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';
const contractPath = path.resolve(__dirname,'../build','contracts_VerificationContract_sol_VerificationContract.abi');
const verificationAbi = fs.readJsonSync(contractPath,'utf-8');

const verificationContractAddressPath = path.resolve(__dirname,'../build','VerificationContract.txt');
const verificationContractAddress = fs.readFileSync(verificationContractAddressPath,'utf-8');

const VerificationContract = new web3.eth.Contract(verificationAbi, verificationContractAddress);

async function verify(logId) {
    const verifyFunction = VerificationContract.methods.verify(logId);
    const gas = await verifyFunction.estimateGas({ from: account });
    const data = verifyFunction.encodeABI();
    const nonce = await web3.eth.getTransactionCount(account);

    const signedTransaction = await web3.eth.accounts.signTransaction({
        to: verificationContractAddress,
        data: data,
        gas: gas,
        nonce: nonce,
        chainId: 5 
    }, privateKey);

    const transactionReceipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);
    //console.log('Transaction receipt:', transactionReceipt);
    verifyFunction.call({from:account},function(err,res){
        if(!err){
            console.log(res);
        }else{
            console.loh(err);
        }
    });
}

var arguments = process.argv.slice(2);
if(!arguments[0]){
    console.log('contractId must be entered');
    return;
}
verify(arguments[0]);