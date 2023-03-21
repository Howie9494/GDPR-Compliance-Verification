// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "../contracts/DataUsageContract.sol";
import "../contracts/AgreementContract.sol";

contract AgreementContractTest {

    AgreementContract agreementContract;
    DataUsageContract dataUsageContract;

    // function beforeEach() public {
    //     agreementContract = new AgreementContract();
    // }
    constructor(address _dataUsageContract, address _agreementContract) {
        agreementContract = AgreementContract(_agreementContract);
        dataUsageContract = DataUsageContract(_dataUsageContract);
    }

    string[] personalDataList;
    function voteTest() public {
        // bytes32 id = 0xda65e898898c9b97743a3d0d08d3d8181e753bdbd504ee0a68fe74273dae276b;
        address hashAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        address actorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        bool userConsent = true;

        string memory serviceName = "healthcare";
        string memory servicePurpose = "data collection";
        personalDataList = ["John", "Newcastle", "24"];
        
        // Declare and assign a value to purposeId
        bytes32 purposeId = dataUsageContract.addPurpose(address(this), serviceName, servicePurpose, Operator.WRITE, personalDataList);


        agreementContract.vote(purposeId, hashAddress, actorAddress, userConsent);
        (address returnedActorAddress, bool returnedUserConsent) = agreementContract.getVote(purposeId);
        Assert.equal(returnedActorAddress, actorAddress, "Actor address is correct");
        Assert.equal(returnedUserConsent, userConsent, "User consent is correct");
    }

    function voteTwiceTest() public {
        address hashAddress = address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        address actorAddress = address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        bool userConsent = true;

        string memory serviceName = "healthcare";
        string memory servicePurpose = "data collection";
        personalDataList = ["John", "Newcastle", "24"];
        
        // Declare and assign a value to purposeId
        bytes32 purposeId = dataUsageContract.addPurpose(address(this), serviceName, servicePurpose, Operator.WRITE, personalDataList);

        agreementContract.vote(purposeId, hashAddress, actorAddress, userConsent);

        // solhint-disable-next-line unused-local-variable
        (bool success,) = address(agreementContract).call(abi.encodeWithSignature("vote(bytes32,address,address,bool)", purposeId, hashAddress, actorAddress, userConsent));
        Assert.ok(false, "Should not be able to vote twice");
    }
}
