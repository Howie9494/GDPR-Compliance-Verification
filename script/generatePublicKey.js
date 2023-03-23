const EthCrypto = require('eth-crypto');
const path = require('path');
const fs = require('fs-extra');

const publicKeyPath = path.resolve(__dirname,'../build','publicKey.txt');
function generate(privateKey){
    const publicKey = EthCrypto.publicKeyByPrivateKey(privateKey);
    fs.outputFileSync(publicKeyPath,publicKey);
}

var arguments = process.argv.slice(2);
if(!arguments[0]){
    console.log('private key must be entered');
    return;
}
generate(arguments[0]);