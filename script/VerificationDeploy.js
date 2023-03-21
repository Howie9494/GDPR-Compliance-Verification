const fs = require('fs-extra');
const path = require('path');

const abiVerificationContractPath = path.resolve(__dirname,'../build','contracts_VerificationContract_sol_VerificationContract.abi');
const verificationAbi = fs.readJsonSync(abiVerificationContractPath,'utf-8');

const binVerificationContractPath = path.resolve(__dirname,'../build','contracts_VerificationContract_sol_VerificationContract.bin');
const verificationBin = fs.readFileSync(binVerificationContractPath,'utf-8');

const verificationContractAddress = path.resolve(__dirname,'../build','VerificationContract.txt');
const dataUsageContractAddress = path.resolve(__dirname,'../build','DataUsageContract.txt');
const dataUsagecontract = fs.readFileSync(dataUsageContractAddress,'utf-8');
const agreementContractAddress = path.resolve(__dirname,'../build','AgreementContract.txt');
const agreementContract = fs.readFileSync(agreementContractAddress,'utf-8');
const logContractAddress = path.resolve(__dirname,'../build','LogContract.txt');
const logContract = fs.readFileSync(logContractAddress,'utf-8');

export async function deployContract(web3,account,privateKey) {
  const deploy = new web3.eth.Contract(verificationAbi)
    .deploy({ 
        data: '0x' + verificationBin,
        arguments:[`${agreementContract}`,`${logContract}`,`${dataUsagecontract}`] })
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
  fs.outputFileSync(verificationContractAddress,transactionReceipt.contractAddress);
}

