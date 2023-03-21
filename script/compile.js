const fs = require('fs-extra');
const solc = require('solc');
const path = require('path');

const contractPath = path.resolve(__dirname,'../contracts','DataUsageContract.sol');
//const enumContractPath = path.resolve(__dirname,'../contracts','enum.sol');
const contractSource = fs.readFileSync(contractPath,'utf-8');

let jsonContractSource = JSON.stringify({
    language: 'Solidity',
    sources: {
        'DataUsageContract.sol': {  // 指明编译的文件名，方便获取数据
            content: contractSource, // 加载的合约文件源代码
        }
    },
    settings: { // 自定义编译输出的格式。以下选择输出全部结果。
        outputSelection: {
            '*': {
                '*': [ '*' ]
            }
        }
    },
});

//let compileResult = solc.compile(jsonContractSource);
console.log('Ready to compile');
compiledCode = JSON.parse(solc.compile(jsonContractSource));
console.log('Compile finished!');
console.log(compiledCode);

abi = compiledCode.contracts['DataUsageContract.sol']['DataUsageContract']['abi'];
let abiPath = path.resolve(__dirname,'../compiled',`DataUsageContract.abi`);
fs.outputJsonSync(abiPath,abi);
//console.log(abi);
console.log("saving abi file to ",abiPath);

bin = compiledCode.contracts['DataUsageContract.sol']['DataUsageContract']['evm']['bytecode']['object'];
let binPath = path.resolve(__dirname,'../compiled',`DataUsageContract.bin`);
fs.outputFileSync(binPath,bin);
//console.log(bin);
console.log("saving bin file to ",binPath);

//solcjs --base-path ./  ./contracts/DataUsageContract.sol --abi --bin -o build
//solcjs --base-path ./  ./contracts/AgreementContract.sol --abi --bin -o build
//solcjs --base-path ./  ./contracts/LogContract.sol --abi --bin -o build
//solcjs --base-path ./  ./contracts/VerificationContract.sol --abi --bin -o build
    
