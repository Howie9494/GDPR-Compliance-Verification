# GDPR-Compliance-Verification
Blockchain-based GDPR Compliance Verification

Compile
solcjs --base-path ./  ./contracts/DataUsageContract.sol --abi --bin -o build
solcjs --base-path ./  ./contracts/AgreementContract.sol --abi --bin -o build
solcjs --base-path ./  ./contracts/LogContract.sol --abi --bin -o build
solcjs --base-path ./  ./contracts/VerificationContract.sol --abi --bin -o build

Deploy 
DataUsageDeploy.js
AgreementDeploy.js
LogContractDeploy.js
VerificationDeploy.js

Test
testFull.js

ContractFuncation <=> Web3.js
DataUsageDeploy.addPurpose() <=> callAddPurpose.js
DataUsageDeploy.getPurposeDetail() <=> callGetPurposeDetail.js [contractId]
AgreementContract.retrieve() <=> callRetrieve.js [contractId]
AgreementContract.vote() <=> callVote.js [contractId] [userConsent]
AgreementContract.editVote() <=> callEditVote.js [contractId] [userConsent]
LogContract.logAction() <=> callLogAction.js [contractId]
VerificationContract.verify() <=> callVerify.js [logId]