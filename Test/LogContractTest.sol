// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "../contracts/LogContract.sol";

contract LogContractTest {
    LogContract logContract;
    
    function beforeEach() public {
        logContract = new LogContract();
    }
    
    function testLogAction() public {
        string[] memory processedData = new string[](2);
        processedData[0] = "data1";
        processedData[1] = "data2";
        bytes32 contractId = keccak256("contractId");
        uint logId = logContract.logAction(address(0x1), Operator.READ, processedData, "TestService", contractId);
        
        (address actorId, Operator operation, string[] memory returnedProcessedData, bytes32 returnedContractId) = logContract.getLog(logId);
        
        Assert.equal(actorId, address(0x1), "Actor address is incorrect");
        Assert.equal(uint(operation), uint(Operator.READ), "Operator is incorrect");
        Assert.equal(returnedProcessedData[0], processedData[0], "Processed data is incorrect");
        Assert.equal(returnedProcessedData[1], processedData[1], "Processed data is incorrect");
        Assert.equal(returnedContractId, contractId, "Contract ID is incorrect");
    }
    
    function testLogActionMaxDataLength() public {
        string[] memory processedData = new string[](257); // length exceeds 256
        bytes32 contractId = keccak256("contractId");
        (bool success, ) = address(logContract).call(abi.encodeWithSignature("logAction(address,enum Operator,string[],string,bytes32)", address(0x1), Operator.READ, processedData, "TestService", contractId));
        Assert.ok(!success, "Should not be able to log with processed data length exceeds 256");
    }
    
    function testLogGetNonExistingLog() public {
        (bool success, ) = address(logContract).call(abi.encodeWithSignature("getLog(uint256)", 1));
        Assert.ok(!success, "Should not be able to get non-existing log");
    }
}
