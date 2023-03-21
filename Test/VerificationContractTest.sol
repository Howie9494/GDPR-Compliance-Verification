// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "../contracts/VerificationContract.sol";

contract VerificationContractTest {
    VerificationContract verificationContract;
    uint logId;
    string[] personalDataList;
    string[] processedData;

    function beforeEach() public {
        verificationContract = new VerificationContract(address(this), address(this), address(this));
        logId = 1;
        personalDataList = ["Jason", "Newcastle", "30"];
        processedData = ["Jason", "Newcastle", "30"];
    }

    function testLoopCompare() public {
        bool result = verificationContract.LoopCompare(personalDataList, processedData);
        Assert.equal(result, true, "LoopCompare succeed");
    }

    function testMappingCompare() public {
        bool result = verificationContract.MappingCompare(personalDataList, processedData);
        Assert.equal(result, true, "MappingCompare succeed");
    }
    
}
