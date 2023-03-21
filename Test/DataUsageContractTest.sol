// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../contracts/DataUsageContract.sol";
import "../contracts/VerificationContract.sol";

contract DataUsageContractTest {

    DataUsageContract contractToTest;
    VerificationContract verificationContract;

    constructor(address _dataUsageContract, address _verificationContract) {
        contractToTest = DataUsageContract(_dataUsageContract);
        verificationContract = VerificationContract(_verificationContract);
    }

    string[] personalDataList;
    function addPurposeTest() public {
        string memory serviceName = "banking";
        string memory servicePurpose = "transaction monitoring";
        personalDataList = ["310 456 789", "2023-03-20 : 30 pounds"];

        // Declare and assign a value to purposeId
        bytes32 purposeId = contractToTest.addPurpose(msg.sender, serviceName, servicePurpose, Operator.WRITE, personalDataList);
        
        bytes32 expectedId = keccak256(abi.encode(msg.sender, serviceName, servicePurpose, Operator.WRITE));
        // bytes32 expectedId = keccak256(abi.encode(address(this), serviceName, servicePurpose, Operator.WRITE));
        // Assert.equal(purposeId, address(this), "Purpose ID is incorrect");
        Assert.equal(purposeId, expectedId, "Purpose ID is incorrect");
    }

    function getPurposeTest() public {
        string memory serviceName = "banking";
        string memory servicePurpose = "transaction monitoring";
        personalDataList = ["310 456 789", "2023-03-20 : 30 pounds"];
       
        // Test for the existence of the purpose
        bytes32 expectedPurposeId = keccak256(abi.encode(msg.sender, serviceName, servicePurpose, Operator.WRITE));
        Assert.equal(contractToTest.addPurpose(msg.sender, serviceName, servicePurpose, Operator.WRITE, personalDataList), expectedPurposeId, "Purpose ID is incorrect");

        // Test the details of the purpose
        (Operator operator, string[] memory storedData) = contractToTest.getPurpose(contractToTest.addPurpose(msg.sender, serviceName, servicePurpose, Operator.WRITE, personalDataList));
        uint receivedOperator = uint(operator);
        uint expectedOperator = uint(Operator.WRITE);
        Assert.equal(receivedOperator, expectedOperator, "Operator is correct");
        Assert.equal(storedData.length, 1, "Data list length is correct");
        Assert.equal(verificationContract.LoopCompare(storedData, personalDataList), true, "Stored data is correct");
    }
}
