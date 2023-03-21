const Web3 = require('web3');
import { DataUsageDeploy } from './DataUsageDeploy.js';
import { AgreementDeploy } from './AgreementDeploy.js';
import { LogDeploy } from './LogDeploy.js';
import { VerificationDeploy } from './VerificationDeploy.js';

const web3 = new Web3('https://goerli.infura.io/v3/2cdd21f1dbc944288cee29de4b52f38d');
const account = '0x910DFBB7e9298Df687827561453342Cb8781C03C';
const privateKey = '83587aef51dfa1653f2f62cfab03dbf224eed84ee4a95912b9bc692ddd81da47';

const dataUsageContractAddress = DataUsageDeploy.deployContract(web3,account,privateKey);
console.log(dataUsageContractAddress);
//AgreementDeploy.deployContract(web3,account,privateKey);
//LogDeploy.deployContract(web3,account,privateKey);
//VerificationDeploy.deployContract(web3,account,privateKey);