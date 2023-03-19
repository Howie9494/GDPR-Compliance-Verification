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
    bool private locked = false;
    mapping(string => uint8) init;

    constructor(address _agreementContract, address _logContract, address _dataUsageContract) {
        agreementContract = AgreementContract(_agreementContract);
        logContract = LogContract(_logContract);
        dataUsageContract = DataUsageContract(_dataUsageContract);
    }

    function verify(uint _logId) public returns(address) {
        require(!locked);
        locked = true;
        // 获取日志信息
        (address logActorId,Operator logOperation, string[] memory processedData,bytes32 contractId) = logContract.getLog(_logId);
        // （1）检查行为人是否符合协议
        (address agreementActorAddress,bool userConsent) = agreementContract.getVote(contractId);
        (Operator dataUseOperation, string[] memory personalDataList) = dataUsageContract.getPurpose(contractId);
        locked = false;

        if (agreementActorAddress != logActorId) {
            return logActorId;
        }

        // 日志合同所记录的每个行为者的操作是否符合那些通过数据使用合同记录并通过协议合同获得用户同意的操作
        // 检查操作是否符合数据使用合同 && 检查该行为人是否已经在ProtocolContract中记录了同意
        if ((dataUseOperation != logOperation) || (!userConsent)) {
            return logActorId;
        } 

        if(personalDataList.length != processedData.length){
            return logActorId;
        }

        // 检查个人数据是否已经被确认
        if(personalDataList.length <= 59){
            if (!LoopCompare(personalDataList,processedData)) {
                return logActorId;
            }
        }else{
            if (!MappingCompare(personalDataList,processedData)) {
                return logActorId;
            }
        }

        return address(0);
    }

    function LoopCompare(string[] memory personalDataList,string[] memory processedData) internal pure returns(bool){
        require(personalDataList.length <= 256);
        uint length = personalDataList.length;
        uint bitMap = 0;
        bytes32[] memory personalDataBytes = new bytes32[](length);
        bytes32[] memory processedDataBytes = new bytes32[](length);
        for(uint i = 0;i < length;i++){
            personalDataBytes[i] = keccak256(abi.encodePacked(personalDataList[i]));
            processedDataBytes[i] = keccak256(abi.encodePacked(processedData[i]));
        }
        for(uint i = 0;i < processedData.length;i++){
            bool flag = false;
            for(uint j = 0;j < personalDataList.length;j++){
                if(personalDataBytes[i] == processedDataBytes[j] && (bitMap & (1 << j)) == 0){
                    bitMap = bitMap | (1 << j);
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

    function MappingCompare(string[] memory personalDataList,string[] memory processedData) internal returns(bool){
        mapping(string => uint8) storage listMap = init;
        for(uint i = 0;i < personalDataList.length;i++){
            listMap[personalDataList[i]] += 1;
        }
        for(uint i = 0;i < processedData.length;i++){
            if(listMap[processedData[i]] == 0){
                clearMapping(listMap,personalDataList);
                return false;
            }
            listMap[processedData[i]] -= 1;
        }
        clearMapping(listMap,personalDataList);
        return true;
    }

    function clearMapping(mapping(string => uint8) storage listMap,string[] memory personalDataList) internal{
        for(uint i = 0;i < personalDataList.length;i++){
            listMap[personalDataList[i]] = 0;
        }
    }
}
