// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract DataUsage{
    
    enum Operator{read,write,transfer}
    address public actorId;
    string public serviceName;
    string public servicePurpose;
    string public operation;
    string public personalDataList;

    constructor(string memory inputServiceName,string memory inputServicePurpose,string memory inputOperation,string memory inputPersonalDataList){
        actorId = msg.sender;
        serviceName = inputServiceName;
        servicePurpose = inputServicePurpose;
        operation = inputOperation;
        personalDataList = inputPersonalDataList;
    }

    function G() public view returns(address){
        return actorId;
    }
}

contract Agreement{
    
}

contract Log{

    event record(address actorId,string operation,string operatedData,string servcieName);

    function logInfo() public returns(address){
        DataUsage dataUsage = new DataUsage("111","111","read","1111");
        return dataUsage.G();
    }
}

contract Verification{
    
}