// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "../contracts/LogContract.sol";

contract LogContractTest {

    LogContract logContract;
    
    constructor(address _logContract) {
        logContract = LogContract(_logContract);
    }
    
    function testLogAction() public {
        
        string[] memory processedData = new string[](3);
        processedData[0] = "John";
        processedData[1] = "London";
        processedData[2] = "24";
        bytes32 contractId = 0xda65e898898c9b97743a3d0d08d3d8181e753bdbd504ee0a68fe74273dae276b;
        uint logId = logContract.logAction(address(this), Operator.READ, processedData, "TestService", contractId);
        
        (address actorId, Operator operation, string[] memory returnedProcessedData, bytes32 returnedContractId) = logContract.getLog(logId);
        
        Assert.equal(actorId, address(this), "Actor address is correct");
        Assert.equal(uint(operation), uint(Operator.READ), "Operator is correct");
        Assert.equal(returnedProcessedData[0], processedData[0], "Processed data is correct");
        Assert.equal(returnedProcessedData[1], processedData[1], "Processed data is correct");
        Assert.equal(returnedProcessedData[2], processedData[2], "Processed data is correct");
        Assert.equal(returnedContractId, contractId, "Contract ID is correct");
    }
    
    function testLogActionMaxDataLength() public {
        string[] memory processedData = new string[](257); // length exceeds 256
        bytes32 contractId = 0xda65e898898c9b97743a3d0d08d3d8181e753bdbd504ee0a68fe74273dae276b;
        (bool success, ) = address(logContract).call(abi.encodeWithSignature("logAction(address,enum Operator,string[],string,bytes32)", address(0x1), Operator.READ, processedData, "TestService", contractId));
        Assert.ok(!success, "Should not be able to log with processed data length exceeds 256");
    }
    
    function testLogGetNonExistingLog() public {
        (bool success, ) = address(logContract).call(abi.encodeWithSignature("getLog(uint256)", 1));
        Assert.ok(!success, "Should not be able to get non-existing log");
    }
}
