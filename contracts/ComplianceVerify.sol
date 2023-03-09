// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ComplianceVerify{
    enum Operator{read,write,transfer}

    struct DataRelationSet{
        address actorId;
        string serviceName;
        string servicePurpose;
        Operator operation;
        string[] personalDataList;
        bool result;
    }

    struct UserConsent{
        address purposeAddress;
        address userId;
        bool consent;
    }

    struct OperateLog{
        address actorId;
        Operator operation;
        string[] operatedData;
        string serviceName;
    }

    mapping(string => DataRelationSet) dataRelationSetMap;
    mapping(string => UserConsent) userConsentMap;
    mapping(address => bool) actorFlag;
    OperateLog[] operateLogList;
}

contract DataUsage is ComplianceVerify{

    function purpose(string memory serviceName,string memory servicePurpose,Operator operation,string[] memory personalDataList) public returns(bool result){
        DataRelationSet memory _dataRelationSet;
        _dataRelationSet.actorId = msg.sender;
        _dataRelationSet.serviceName = serviceName;
        _dataRelationSet.servicePurpose = servicePurpose;
        _dataRelationSet.operation = operation;
        _dataRelationSet.personalDataList = personalDataList;

        result = true;
        if(true){
            //判断是否加密
            result = false;
        }
        if(actorFlag[msg.sender]){
            result = false;
        }
        
        _dataRelationSet.result = result;

        dataRelationSetMap[serviceName] = _dataRelationSet;

        return result;
    }

}

contract Agreement is ComplianceVerify{

    string reviewingService;

    function Retrieve(string memory serviceName) public returns(DataRelationSet memory dataRelationSet){
        reviewingService = serviceName;
        return dataRelationSetMap[serviceName];
    }

    function Vote(address purposeAddress,bool consent) public returns(bool userConsent){
        //Determining whether data use is compliant
        if(dataRelationSetMap[reviewingService].result){
            UserConsent memory _userConsent;
            _userConsent.purposeAddress = purposeAddress;
            _userConsent.userId = msg.sender;
            _userConsent.consent = consent;

            userConsentMap[reviewingService] = _userConsent;
            return true;
        }
        return false;
    }

}

contract Log is ComplianceVerify{

    event record(address actorId,Operator operation,string[] operatedData,string serviceName);

    function logInfo(address actorId,Operator operation,string[] memory operatedData,string memory serviceName) public returns(bool result){
        OperateLog memory _operateLog;

        _operateLog.actorId = actorId;
        _operateLog.operation = operation;
        _operateLog.operatedData = operatedData;
        _operateLog.serviceName = serviceName;

        operateLogList.push(_operateLog);
        emit record(actorId,operation,operatedData,serviceName);
        return true;
    }

}

contract Verification is ComplianceVerify{

    uint validatedLogIndex = 0;

    function verify() public returns(address violationId){
        for(uint i = validatedLogIndex;i < operateLogList.length;i++){
            validatedLogIndex =  i + 1;
            actorFlag[dataRelationSetMap[operateLogList[i].serviceName].actorId] = true;
            //用户是否同意
            if(!userConsentMap[operateLogList[i].serviceName].consent){
                actorFlag[dataRelationSetMap[operateLogList[i].serviceName].actorId] = false;
                return dataRelationSetMap[operateLogList[i].serviceName].actorId;
            }
            //同意的用户是否一致
            if(operateLogList[i].actorId != userConsentMap[operateLogList[i].serviceName].userId){
                actorFlag[dataRelationSetMap[operateLogList[i].serviceName].actorId] = false;
                return dataRelationSetMap[operateLogList[i].serviceName].actorId;
            }
            //日志的操作和数据使用的操作是否一致
            if(operateLogList[i].operation != dataRelationSetMap[operateLogList[i].serviceName].operation){
                actorFlag[dataRelationSetMap[operateLogList[i].serviceName].actorId] = false;
                return dataRelationSetMap[operateLogList[i].serviceName].actorId;
            }
            //日志中已使用的数据是否都同意
            if(CompareArray(operateLogList[i].operatedData,dataRelationSetMap[operateLogList[i].serviceName].personalDataList)){
                actorFlag[dataRelationSetMap[operateLogList[i].serviceName].actorId] = false;
                return dataRelationSetMap[operateLogList[i].serviceName].actorId;
            }
        }
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
        bytes memory byteStr1 = bytes(str1);
        bytes memory byteStr2 = bytes(str2);
        if (byteStr1.length != byteStr2.length) return false;
        for(uint i = 0; i < byteStr1.length; i ++) {
            if(byteStr1[i] != byteStr2[i]) return false;
        }
        return true;
    }
}