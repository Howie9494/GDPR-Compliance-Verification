// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./DataUsageContract.sol";
import "./enum.sol";
/**
 * @title AgreementContract
 * @notice This contract manages user votes on agreements between users and actors.
 * It contains methods to submit a vote and retrieve a vote by its unique ID.
 * The contract uses a struct to store vote information and a mapping to associate each vote with a unique ID.
 */
contract AgreementContract {
    // struct to store information related to a user vote.
    struct Vote {
        bytes32 id; // Unique ID for the vote
        address hashAddress; // Hashed address of the agreement
        address userId; // Address of the user who voted
        address actorAddress; // Address of the actor associated with the agreement
        bool userConsent; // User's consent to the agreement (true = consent, false = reject)
    }

    // Mapping to store votes by their unique ID (bytes32)
    mapping(bytes32 => Vote) private voteMap;

    // DataUsageContract instance to retrieve data usage terms
    DataUsageContract private dataUsageContract;

    constructor(address _dataUsageContract) {
        dataUsageContract = DataUsageContract(_dataUsageContract);
    }

    function retrieve(bytes32 _id) public view returns (bytes32,address,address,Operator,string memory,string memory,string[] memory){
        return dataUsageContract.getPurposeDetail(_id);
    }
    
    /**
     * @notice Submits a user vote on an agreement.
     * @param _id Unique ID for the vote.
     * @param _hashAddress Hashed address of the agreement.
     * @param _actorAddress Address of the actor associated with the agreement.
     * @param _userConsent User's consent to the agreement (true = consent, false = reject).
     */
    function vote(bytes32 _id, address _hashAddress, address _actorAddress, bool _userConsent) public {
        address _userId = msg.sender;
        require(dataUsageContract.getDataOwner(_id) == _userId,"only be agreed by the user-owner");
        // Store the vote information in the mapping
        voteMap[_id] = Vote(_id, _hashAddress, _userId, _actorAddress, _userConsent);
    }

    function editVote(bytes32 _id,bool _userConsent) public{
        require(voteMap[_id].id != 0, "Vote does not exist");
        require(voteMap[_id].userId == msg.sender,"only be edited by the user-owner");
        voteMap[_id].userConsent = _userConsent;
    }

    /**
     * @notice Retrieves information about a vote by its unique ID.
     * @param _id Unique ID for the vote.
     * @return actorAddress Address of the actor associated with the agreement.
     * @return userConsent User's consent to the agreement (true = consent, false = reject).
     */
    function getVote(bytes32 _id) public view returns (address, bool) {
        require(voteMap[_id].id != 0, "Vote does not exist");
        Vote storage vt = voteMap[_id];
        return (vt.actorAddress, vt.userConsent);
    }
}
