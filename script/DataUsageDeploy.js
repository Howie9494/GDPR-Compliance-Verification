const Web3 = require('web3');
const fs = require('fs-extra');
const path = require('path');

const web3 = new Web3('https://goerli.infura.io/v3/2cdd21f1dbc944288cee29de4b52f38d');
const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';

const abiDataUsageContractPath = path.resolve(__dirname,'../build','contracts_DataUsageContract_sol_DataUsageContract.abi');
const dataUsageAbi = fs.readJsonSync(abiDataUsageContractPath,'utf-8');

const binDataUsageContractPath = path.resolve(__dirname,'../build','contracts_DataUsageContract_sol_DataUsageContract.bin');
const dataUsageBin = fs.readFileSync(binDataUsageContractPath,'utf-8');

const dataUsageContractAddress = path.resolve(__dirname,'../build','DataUsageContract.txt');

async function deployContract() {
  const deploy = new web3.eth.Contract(dataUsageAbi)
    .deploy({ data: '0x' + dataUsageBin })
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
  fs.outputFileSync(dataUsageContractAddress,transactionReceipt.contractAddress);
  return transactionReceipt.contractAddress;
}

deployContract();