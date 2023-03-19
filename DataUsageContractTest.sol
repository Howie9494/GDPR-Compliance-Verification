// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../contracts/DataUsageContract.sol";

contract DataUsageContractTest {

    DataUsageContract contractToTest;

    function beforeEach() public {
        contractToTest = new DataUsageContract();
    }

    function addPurposeTest() public {
        string memory serviceName = "test service";
        string memory servicePurpose = "test purpose";
        string[] memory personalDataList = new string[](1);
        personalDataList[0] = "test data";
        
        // Declare and assign a value to purposeId
        bytes32 purposeId = contractToTest.addPurpose(serviceName, servicePurpose, Operator.WRITE, personalDataList);
        
        bytes32 expectedId = keccak256(abi.encode(msg.sender, serviceName, servicePurpose, Operator.WRITE));
        Assert.equal(purposeId, expectedId, "Purpose ID is incorrect");
    }

    function getPurposeTest() public {
        string memory serviceName = "test service";
        string memory servicePurpose = "test purpose";
        string[] memory personalDataList = new string[](1);
        personalDataList[0] = "test data";
        bytes32 purposeId = contractToTest.addPurpose(serviceName, servicePurpose, Operator.WRITE, personalDataList);

        // Test for the existence of the purpose
        bytes32 receivedPurposeId = purposeId;
        bytes32 expectedPurposeId = keccak256(abi.encode(msg.sender, serviceName, servicePurpose, Operator.WRITE));
        Assert.equal(receivedPurposeId, expectedPurposeId, "Purpose ID is incorrect");

        // Test the details of the purpose
        (Operator operator, string[] memory storedData) = contractToTest.getPurpose(purposeId);
        uint receivedOperator = uint(operator);
        uint expectedOperator = uint(Operator.WRITE);
        Assert.equal(receivedOperator, expectedOperator, "Operator is incorrect");
        Assert.equal(storedData.length, 1, "Data list length is incorrect");
        Assert.equal(storedData[0], "test data", "Stored data is incorrect");
    }

}