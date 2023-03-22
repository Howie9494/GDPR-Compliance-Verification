// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "../contracts/VerificationContract.sol";
import "../contracts/AgreementContract.sol";
import "../contracts/LogContract.sol";
import "../contracts/DataUsageContract.sol";
import "../contracts/enum.sol";

contract IntegrationTest {

    AgreementContract agreementContract;
    LogContract logContract;
    DataUsageContract dataUsageContract;
    VerificationContract verificationContract;

    constructor(address _dataUsageContract, address _agreementContract, address _logContract, address _verificationContract) {
        agreementContract = AgreementContract(_agreementContract);
        dataUsageContract = DataUsageContract(_dataUsageContract);
        logContract = LogContract(_logContract);
        logId = logContract.logAction(actorId, dataUseOperation, processedData, "healthcare", contractId);

        verificationContract = VerificationContract(_verificationContract);
    }

    Operator dataUseOperation = Operator.WRITE;
    string[] personalDataList = ["Jason", "jason666@newcastle.ac.uk", "30"];
    string[] processedData = ["Jason", "jason666@newcastle.ac.uk", "30"];
    // bytes32 agreementId = keccak256(abi.encodePacked("test_agreement"));
    bytes32 contractId = 0x72c3b3978085435fb37ce6b693eaae2644d37a1af525aec01cff897a87252b83;
    address actorId = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint logId;

    function checkContractCreation() public {
        // Test contract creation with incorrect contract addresses
        VerificationContract verificationContractInvalid = new VerificationContract(address(0), address(0), address(0));
        Assert.equal(address(verificationContractInvalid), address(0), "Invalid contract addresses");

        // Test contract creation with invalid, null or illegal fields
        VerificationContract verificationContractInvalidAddress = new VerificationContract(address(this), address(0), address(0));
        Assert.equal(address(verificationContractInvalidAddress), address(0), "Invalid agreement contract address");
        VerificationContract verificationContractInvalidNull = new VerificationContract(address(this), address(this), address(0));
        Assert.equal(address(verificationContractInvalidNull), address(0), "Invalid data usage contract address");
        VerificationContract verificationContractInvalidField = new VerificationContract(address(this), address(this), address(this));
        Assert.notEqual(address(verificationContractInvalidField), address(0), "Invalid log contract field");
    }

    function testVerify() public {
        // verify log information
        (address actorId1, Operator dataUseOperation1, string[] memory processedData1, bytes32 contractId1) = logContract.getLog(logId);
        Assert.equal(actorId1, actorId, "Log actor address should be equal to agreement actor address");
        Assert.equal((dataUseOperation1 == Operator.WRITE), true, "Log operation should be equal to the one set in data usage contract");
        Assert.equal(contractId1, contractId, "Log contract ID should be equal to agreement ID");

        // verify vote information
        (address agreementActorAddress, bool userConsent) = agreementContract.getVote(contractId);
        Assert.equal(agreementActorAddress, actorId, "Agreement actor address should be equal to the one set during agreement creation");
        Assert.equal(userConsent, true, "User should have given consent");

        // verify data usage information
        (Operator dataUseOperation2, string[] memory processedData2) = dataUsageContract.getPurpose(contractId);
        Assert.equal((dataUseOperation2 == Operator.WRITE), true, "Data use operation should be equal to the one set during data usage contract creation");
        Assert.equal(personalDataList.length, 3, "Number of personal data fields should be equal to the one set during data usage contract creation");

        // verify log verification
        Assert.equal(verificationContract.verify(logId) == address(0), true, "Verification should return 0 address when all checks pass");

        // Test incorrect contract addresses
        VerificationContract verificationContractWrongAddress = new VerificationContract(address(0x0), address(0x0), address(0x0));
        Assert.equal(address(verificationContractWrongAddress), address(0), "Contract creation should fail with incorrect addresses");

        // Test illegal address
        VerificationContract verificationContractIllegalAddress = new VerificationContract(address(this), address(0x0), address(0x0));
        Assert.equal(address(verificationContractIllegalAddress), address(0), "Contract creation should fail with illegal addresses");

        // Test null address
        VerificationContract verificationContractNullAddress = new VerificationContract(address(0), address(0), address(0));
        Assert.equal(address(verificationContractNullAddress), address(0), "Contract creation should fail with null addresses");

        // Test illegal fields
        VerificationContract verificationContractIllegalFields = new VerificationContract(address(agreementContract), address(logContract), address(dataUsageContract));
        Assert.equal(address(verificationContractIllegalFields), address(this), "Contract creation should succeed with legal fields");

        // Add a log entry to the LogContract
        // address _actorId, Operator _operation, string[] memory _processedData, string memory _serviceName, bytes32 _contractId
        logContract.logAction(address(this), Operator.WRITE, processedData, "healthcare", contractId);

        // Set the data usage purpose to "Add"
        // address dataOwner,string memory _serviceName, string memory _servicePurpose, Operator _operation, string[] memory _personalDataList
        dataUsageContract.addPurpose(msg.sender, "healthcare", "data collection", Operator.WRITE, processedData);

        // Verify that the VerificationContract correctly identifies the log entry as valid
        Assert.equal(verificationContract.verify(logId), address(0), "Invalid log entry");
    }

    function testVerifyInvalidActor() public {
        // Add a log entry to the LogContract with an invalid actor
        logContract.logAction(address(this), Operator.WRITE, processedData, "healthcare", contractId);

        // Verify that the VerificationContract correctly identifies the log entry as invalid
        Assert.equal(verificationContract.verify(logId), address(this), "Invalid actor");
    }

    function testVerifyInvalidDataUsage() public {
        // Add a log entry to the LogContract
        logContract.logAction(address(this), Operator.WRITE, processedData, "healthcare", contractId);

        // Set the data usage purpose to "Delete"
        dataUsageContract.addPurpose(msg.sender, "healthcare", "data collection", Operator.WRITE, processedData);

        // Verify that the VerificationContract correctly identifies the log entry as invalid
        Assert.equal(verificationContract.verify(logId), address(this), "Invalid data usage");
    }

    function testVerifyInvalidData() public {
        // Add a log entry to the LogContract with invalid data
        logContract.logAction(address(this), Operator.WRITE, processedData, "healthcare", contractId);

        // Set the data usage purpose to "Add"
        dataUsageContract.addPurpose(msg.sender, "healthcare", "data collection", Operator.WRITE, processedData);

        // Verify that the VerificationContract correctly identifies the log entry as invalid
        Assert.equal(verificationContract.verify(logId), address(this), "Invalid data");
    }
    
}