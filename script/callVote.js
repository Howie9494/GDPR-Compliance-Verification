const Web3 = require('web3');
const path = require('path');
const fs = require('fs-extra');

const web3 = new Web3('https://goerli.infura.io/v3/8ace39a5a8ab475eb44a15774dc5a293');
const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';

const agreementContractPath = path.resolve(__dirname,'../build','contracts_AgreementContract_sol_AgreementContract.abi');
const agreementAbi = fs.readJsonSync(agreementContractPath,'utf-8');

const agreementContractAddressPath = path.resolve(__dirname,'../build','VerificationContract.txt');
const agreementContractAddress = fs.readFileSync(agreementContractAddressPath,'utf-8');

// // Create a contract instance
const agreementContract = new web3.eth.Contract(agreementAbi, agreementContractAddress);

async function vote() {
    const contractId = '0xa65d1861820be6e946780f9338bce97157b83d17808dbe8a97c32c50e11b8135';
    const hashAddress = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
    const actorAddress = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
    const userConsent = true;

    const voteFunction = agreementContract.methods.vote(contractId,hashAddress,actorAddress,userConsent);
    const gas = await voteFunction.estimateGas({ from: account });
    const data = voteFunction.encodeABI();
    const nonce = await web3.eth.getTransactionCount(account);

    const signedTransaction = await web3.eth.accounts.signTransaction({
        to: contractAddress,
        data: data,
        gas: gas,
        nonce: nonce,
        chainId: 5 
    }, privateKey);

    const transactionReceipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);

    voteFunction.call({from:account},function(err,res){
        if(!err){
            console.log(res)
        }else{
            console.log(err);
        }
    })
    // console.log('Transaction receipt:', transactionReceipt);
}
vote();
