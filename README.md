# GDPR-Compliance-Verification
## Blockchain-based GDPR Compliance Verification

### Compile

`solcjs --base-path ./  ./contracts/DataUsageContract.sol --abi --bin -o build`

`solcjs --base-path ./  ./contracts/AgreementContract.sol --abi --bin -o build`

`solcjs --base-path ./  ./contracts/LogContract.sol --abi --bin -o build`

`solcjs --base-path ./  ./contracts/VerificationContract.sol --abi --bin -o build`


### Deploy 

`node DataUsageDeploy.js`

`node AgreementDeploy.js`

`node LogContractDeploy.js`

`node VerificationDeploy.js`

### Test

`node testFull.js`

### Interface correspondence

`ContractFuncation <=> Web3.js`

`DataUsageDeploy.addPurpose() <=> callAddPurpose.js`

`DataUsageDeploy.getPurposeDetail() <=> callGetPurposeDetail.js [contractId]`

`AgreementContract.retrieve() <=> callRetrieve.js [contractId]`

`AgreementContract.vote() <=> callVote.js [contractId] [userConsent]`

`AgreementContract.editVote() <=> callEditVote.js [contractId] [userConsent]`

`LogContract.logAction() <=> callLogAction.js [contractId]`

`VerificationContract.verify() <=> callVerify.js [logId]`


## Auto-Deploy

`python .\script\autoDeploy.py  `

## Realistic scenarios
Provider：
1. Run the automatic deployment script.

2. Start the monitoring script.

3. Send 'contracts_VerificationContract_sol_VerificationContract.abi' and 'VerificationContract.txt' to dataOwner.

4. Send 'contracts_DataUsageContract_sol_DataUsageContract.abi','DataUsageContract.txt','contracts_LogContract_sol_LogContract.abi' and 'LogContract.txt' to actor.

DataOwner:
1. Use the public key generation script to obtain the public key and send it to the actor.

2. Look up usage information and vote based on the unique Id of the data usage contract(Voting changes can be made).

Actor:
1. Create a record using the public key to add data and send the unique Id of the record to the dataOwner.

2. Logging data usage using logAction.
