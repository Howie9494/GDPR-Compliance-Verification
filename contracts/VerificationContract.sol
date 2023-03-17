// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./AgreementContract.sol";
import "./LogContract.sol";
import "./DataUsageContract.sol";
import "./enum.sol";

contract VerificationContract {

    AgreementContract private agreementContract;
    LogContract private logContract;
    DataUsageContract private dataUsageContract;   

    constructor(address _agreementContract, address _logContract, address _dataUsageContract) {
        agreementContract = AgreementContract(_agreementContract);
        logContract = LogContract(_logContract);
        dataUsageContract = DataUsageContract(_dataUsageContract);
    }

    function verify(uint _logId) public view returns(address) {
        // 获取日志信息
        (address logActorId,Operator logOperation, string[] memory processedData,bytes32 contractId) = logContract.getLog(_logId);
        // （1）检查行为人是否符合协议
        (address agreementActorAddress,bool userConsent) = agreementContract.getVote(contractId);

        if (agreementActorAddress != logActorId) {
            return logActorId;
        }

        // 日志合同所记录的每个行为者的操作是否符合那些通过数据使用合同记录并通过协议合同获得用户同意的操作
        // 检查操作是否符合数据使用合同 && 检查该行为人是否已经在ProtocolContract中记录了同意
         (Operator dataUseOperation, string[] memory personalDataList) = dataUsageContract.getActor(contractId);
        if ((dataUseOperation != logOperation) || (!userConsent)) {
            return logActorId;
        } 

        if(personalDataList.length != processedData.length){
            return logActorId;
        }

        // 检查个人数据是否已经被确认
        if (!CompareArray(personalDataList,processedData)) {
            return logActorId;
        }
        return address(0);
    }

    function CompareArray(string[] memory personalDataList,string[] memory operatedData) internal pure returns(bool){
        for(uint i = 0;i < operatedData.length;i++){
            bool flag = false;
            for(uint j = 0;j < personalDataList.length;j++){
                if(isEqual(operatedData[i],personalDataList[j])){
                    flag = true;
                    break;
                }
            }
            if(!flag){
                return false;
            }
            flag = false;
        }
        return true;
    }

    function isEqual(string memory str1, string memory str2) internal pure returns (bool) {
        if(bytes(str1).length != bytes(str2).length){
            return false;
        }else if(bytes(str1).length <= 2){
            bytes memory byteStr1 = bytes(str1);
            bytes memory byteStr2 = bytes(str2);
            for(uint i = 0; i < byteStr1.length; i ++) {
                if(byteStr1[i] != byteStr2[i]) return false;
            }
            return true;
        }else{
            return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
        }
    }
}
