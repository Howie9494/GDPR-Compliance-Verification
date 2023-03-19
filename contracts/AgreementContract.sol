// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

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

    /**
     * @notice Submits a user vote on an agreement.
     * @param _id Unique ID for the vote.
     * @param _hashAddress Hashed address of the agreement.
     * @param _userId Address of the user who voted.
     * @param _actorAddress Address of the actor associated with the agreement.
     * @param _userConsent User's consent to the agreement (true = consent, false = reject).
     */
    function vote(bytes32 _id, address _hashAddress, address _userId, address _actorAddress, bool _userConsent) public {
        // Ensure the user has not already voted
        require(voteMap[_id].id == 0, "The user has already voted.");
        // Store the vote information in the mapping
        voteMap[_id] = Vote(_id, _hashAddress, _userId, _actorAddress, _userConsent);
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
