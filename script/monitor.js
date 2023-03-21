const fs = require('fs-extra');
const path = require('path');
const Web3 = require('web3');

//const web3 = new Web3('wss://goerli.infura.io/v3/8ace39a5a8ab475eb44a15774dc5a293/ws');
const web3 = new Web3(new Web3.providers.WebsocketProvider('wss://goerli.infura.io/ws/v3/2cdd21f1dbc944288cee29de4b52f38d'));
const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';

const abiLogContractPath = path.resolve(__dirname,'../build','contracts_LogContract_sol_LogContract.abi');
var logAbi = fs.readJsonSync(abiLogContractPath,'utf-8');

const logContractAddress = path.resolve(__dirname,'../build','LogContract.txt');
const logContract = fs.readFileSync(logContractAddress,'utf-8');

var ClientReceipt = new web3.eth.Contract(logAbi,logContract);
//var clientReceipt = ClientReceipt.at(logContract);
//var depositEvent = clientReceipt.Deposit();

// 监视变化
//depositEvent.getInfo(function(error, result){
    // 结果包含非索引的参数和给 `Deposit` 调用的 topics。
    //if (!error)
        //console.log(result);
//});

var recordEvent = ClientReceipt.events.record({
    filter: {},
    chainId: 5
}, function (error, event) { 
    if(!error){
        let logId = event['returnValues'][0];
        verify(logId);
        console.log('Validation complete');
    }else{
        console.log(error);
    } 
})

const contractPath = path.resolve(__dirname,'../build','contracts_VerificationContract_sol_VerificationContract.abi');
const verificationAbi = fs.readJsonSync(contractPath,'utf-8');

const verificationContractAddress = path.resolve(__dirname,'../build','VerificationContract.txt');
const verificationContract = fs.readFileSync(verificationContractAddress,'utf-8');

const VerificationContract = new web3.eth.Contract(verificationAbi, verificationContract);

async function verify(logId) {
    const verifyFunction = VerificationContract.methods.verify(logId);
    const gas = await verifyFunction.estimateGas({ from: account });
    const data = verifyFunction.encodeABI();
    const nonce = await web3.eth.getTransactionCount(account);

    const signedTransaction = await web3.eth.accounts.signTransaction({
        to: verificationContract,
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
