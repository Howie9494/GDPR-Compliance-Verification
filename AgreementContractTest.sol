// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "../contracts/AgreementContract.sol";

contract AgreementContractTest {
    AgreementContract agreementContract;

    function beforeEach() public {
        agreementContract = new AgreementContract();
    }

    function voteTest() public {
        bytes32 id = keccak256(abi.encodePacked("testId"));
        address hashAddress = address(0x1);
        address userId = address(0x2);
        address actorAddress = address(0x3);
        bool userConsent = true;
        agreementContract.vote(id, hashAddress, userId, actorAddress, userConsent);
        (address returnedActorAddress, bool returnedUserConsent) = agreementContract.getVote(id);
        Assert.equal(returnedActorAddress, actorAddress, "Actor address is incorrect");
        Assert.equal(returnedUserConsent, userConsent, "User consent is incorrect");
    }

    function voteTwiceTest() public {
        bytes32 id = keccak256(abi.encodePacked("testId"));
        address hashAddress = address(0x1);
        address userId = address(0x2);
        address actorAddress = address(0x3);
        bool userConsent = true;
        agreementContract.vote(id, hashAddress, userId, actorAddress, userConsent);

        // solhint-disable-next-line unused-local-variable
        (bool success,) = address(agreementContract).call(abi.encodeWithSignature("vote(bytes32,address,address,address,bool)", id, hashAddress, userId, actorAddress, userConsent));
        Assert.ok(false, "Should not be able to vote twice");
    }
}