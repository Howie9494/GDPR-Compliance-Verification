// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./enum.sol";

/**
 * @title LogContract
 * @notice This contract manages logging of data processing actions for different services.
 * It contains methods to log a data processing action and retrieve information about a specific log entry by its ID.
 * The contract uses a struct to store log entry information and a mapping to associate each log entry with a unique ID.
 * Events are emitted when a new log entry is added.
 */
contract LogContract {
    
    // LogEntry struct to store information related to a data processing action.
    struct LogEntry {
        uint id; //Unique identifier for the log entry.
        address actorId; //Address of the actor who performed the action.
        Operator operation; //Operator enum value indicating the operation performed.
        string[] processedData; //Array of processed data items.
        string serviceName; //Name of the service associated with the action.
        bytes32 contractId; //Unique identifier of the associated DataUsageContract.
    }

    // Mapping to store log entries by their unique ID (uint)
    mapping(uint => LogEntry) private logList;

    // Event emitted when a new log entry is added.
    event record(uint indexed _id, address indexed _actorId, Operator _operation, string[] _operatedData, string _serviceName, bytes32 _contractId);

    // Counter to keep track of the current log entry ID
    uint private currentLog = 0;

    /**
     * @notice Logs a data processing action.
     * @param _actorId Address of the actor who performed the action.
     * @param _operation Operator enum value indicating the operation performed.
     * @param _processedData Array of processed data items.
     * @param _serviceName Name of the service associated with the action.
     * @param _contractId Unique identifier of the associated DataUsageContract.
     * @return logId Unique identifier for the newly created log entry.
     */
    function logAction(address _actorId, Operator _operation, string[] memory _processedData, string memory _serviceName, bytes32 _contractId) public returns (uint logId) {
        // Ensure the processed data list has no more than 256 elements to prevent excessive data storage.
        require(_processedData.length <= 256, "The length of the processed data cannot exceed 256");
        currentLog++;
        logList[currentLog] = LogEntry(currentLog, _actorId, _operation, _processedData, _serviceName, _contractId);
        emit record(currentLog, _actorId, _operation, _processedData, _serviceName, _contractId);
        return currentLog;
    }

    /**
     * @notice Retrieves information about a log entry by its unique ID.
     * @param _id Unique identifier for the log entry.
     * @return actorId Address of the actor who performed the action.
     * @return operation Operator enum value indicating the operation performed.
     * @return processedData Array of processed data items.
     * @return contractId Unique identifier of the associated DataUsageContract.
     */
    function getLog(uint _id) public view returns (address actorId, Operator operation, string[] memory processedData, bytes32 contractId) {
        require(logList[_id].id != 0, "Log does not exist");
        LogEntry storage log = logList[_id];
        return (log.actorId, log.operation, log.processedData, log.contractId);
    }
}
