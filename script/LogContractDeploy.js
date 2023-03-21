const Web3 = require('web3');
const fs = require('fs-extra');
const path = require('path');

const web3 = new Web3('https://goerli.infura.io/v3/2cdd21f1dbc944288cee29de4b52f38d');
const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';

const abiLogContractPath = path.resolve(__dirname,'../build','contracts_LogContract_sol_LogContract.abi');
const logAbi = fs.readJsonSync(abiLogContractPath,'utf-8');

const binLogContractPath = path.resolve(__dirname,'../build','contracts_LogContract_sol_LogContract.bin');
const logBin = fs.readFileSync(binLogContractPath,'utf-8');

const logContractAddress = path.resolve(__dirname,'../build','LogContract.txt');

async function deployContract() {
  const deploy = new web3.eth.Contract(logAbi)
    .deploy({ data: '0x' + logBin })
    .encodeABI();

  const gas = await web3.eth.estimateGas({ from: account, data: deploy });
  const nonce = await web3.eth.getTransactionCount(account);

  const signedTransaction = await web3.eth.accounts.signTransaction(
    {
      to: null,
      data: deploy,
      gas: gas,
      nonce: nonce,
      chainId: 5,
    },
    privateKey
  );

  const transactionReceipt = await web3.eth.sendSignedTransaction(
    signedTransaction.rawTransaction
  );
  console.log('Deployed contract address:', transactionReceipt.contractAddress);
  fs.outputFileSync(logContractAddress,transactionReceipt.contractAddress);
}

deployContract();