// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./enum.sol";
// 一个简单的日志合约，用于存储操作日志
contract LogContract {
    
    // 定义日志的数据结构，包括操作者ID、操作者地址、操作内容、操作涉及的个人数据以及涉及的服务名称
    struct LogEntry {
        uint id;
        address actorId; // 操作者ID
        Operator operation; // 操作内容
        string[] processedData; // 操作涉及的个人数据
        string serviceName; // 涉及的服务名称
    }

    // 存储所有的日志信息，mapping结构，将日志ID映射到LogEntry结构体类型
    mapping(uint => LogEntry) private logList;

    event record(uint _id,address _actorId,Operator _operation,string[] _operatedData,string _serviceName);

    uint currentLog = 0;

    // 添加新的日志信息
    function logAction(address _actorId,Operator _operation, string[] memory _processedData, string memory _serviceName) public returns(uint){
        ++currentLog;
        logList[currentLog] = LogEntry(currentLog,_actorId,_operation, _processedData, _serviceName); // 将新的日志加入mapping
        emit record(currentLog,_actorId,_operation, _processedData, _serviceName);
        return currentLog;
    }

    // 获取一条日志记录
    function getLog(uint _id) public view returns (address, Operator, string[] memory) {
        require(logList[_id].id != 0, "Log does not exist"); // 确保指定的日志id存在
        LogEntry storage log = logList[_id]; // 获取指定日志id的日志记录
        return (log.actorId, log.operation, log.processedData); // 返回日志记录的各个字段
    }

}

