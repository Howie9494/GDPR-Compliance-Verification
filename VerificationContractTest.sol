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
        personalDataList = ["data1", "data2", "data3", "data4", "data5"];
        processedData = ["data2", "data4", "data1", "data5", "data3"];
    }

    function testLoopCompare() public {
        bool result = verificationContract.LoopCompare(personalDataList, processedData);
        Assert.equal(result, true, "LoopCompare failed");
    }

    function testMappingCompare() public {
        bool result = verificationContract.MappingCompare(personalDataList, processedData);
        Assert.equal(result, true, "MappingCompare failed");
    }
    
    // function testClearMapping() public {
    //     verificationContract.clearMapping(verificationContract.init, personalDataList);

    //     for (uint i = 0; i < personalDataList.length; i++) {
    //         Assert.equal(verificationContract.init[personalDataList[i]], 0, "clearMapping failed");
    //     }
    // }
}