// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./enum.sol";

/**
 * @notice DataUsageContract manages data usage purposes for different services.
 * It contains two methods:
 * - addPurpose: Adds a new data usage purpose.
 * - getPurpose: get a data usage purpose by its unique ID.
 */
 contract DataUsageContract {
    /**
     *  struct to store information related to the data usage purpose.
     */
    struct Purpose {
        bytes32 id; // Unique ID for the data usage purpose
        address actorId; //Address of the actor who created the purpose
        address dataOwner; //Address of the data list owner
        Operator operation; //Enum value {READ,WRITE,TRANSFER}
        string serviceName; //Name of the service associated with the purpose.
        string servicePurpose; //Description of the purpose for which the service will use the personal data.
        string[] personalDataList; //Array of personal data items to be used for the specified purpose.
    }

    // Mapping to store purposes by their unique ID (bytes32)
    mapping(bytes32 => Purpose) private purposeMap;

    /**
     * @notice Adds a new data usage purpose.
     * @param _serviceName Name of the service.
     * @param _servicePurpose Description of the purpose.
     * @param _operation Operator enum value.
     * @param _personalDataList Array of personal data items.
     * @return id Unique identifier for the new purpose.
     */
    function addPurpose(address dataOwner,string memory _serviceName, string memory _servicePurpose, Operator _operation, string[] memory _personalDataList) public returns (bytes32 id) {
        // Ensure the data list has no more than 256 elements to prevent excessive data storage.
        require(_personalDataList.length <= 256, "The length of the data list cannot exceed 256"); 
        address actorId = msg.sender;
        // Generate a unique ID for the purpose using a hash of the actorId, serviceName, servicePurpose, and operation.
        id = keccak256(abi.encode(actorId, _serviceName, _servicePurpose, _operation));
        purposeMap[id] = Purpose(id, actorId, dataOwner, _operation, _serviceName, _servicePurpose, _personalDataList);
        return id;
    }

    /**
     * @notice Retrieves information about a data usage purpose by its unique ID.
     * @param _id Unique identifier for the purpose.
     * @return operation Operator enum value.
     * @return personalDataList Array of personal data items.
     */
    function getPurpose(bytes32 _id) public view returns (Operator operation, string[] memory personalDataList) {
        require(purposeMap[_id].id != 0, "Purpose does not exist");
        Purpose storage purpose = purposeMap[_id];
        return (purpose.operation, purpose.personalDataList);
    }

    /**
     * @notice Retrieves data owner about a data usage purpose by its unique ID.
     * @param _id Unique identifier for the purpose.
     * @return dataOwner address.
     */
    function getDataOwner(bytes32 _id) public view returns (address dataOwner) {
        require(purposeMap[_id].id != 0, "Purpose does not exist");
        return purposeMap[_id].dataOwner;
    }

    /**
     * @notice Retrieves all information about a data usage purpose by its unique ID.
     * @param _id Unique identifier for the purpose.
     * @return id Unique identifier for the new purpose.
     * @return actorId ,address of the actor who created the purpose
     * @return dataOwner ,addresss of data owner.
     * @return operation Operator enum value.
     * @return serviceName ,name of the service associated with the purpose.
     * @return servicePurpose ,description of the purpose for which the service will use the personal data.
     * @return personalDataList ,array of personal data items to be used for the specified purpose.
     */
    function getPurposeDetail(bytes32 _id) public view returns (bytes32 id,address actorId,address dataOwner,Operator operation,string memory serviceName,string memory servicePurpose,string[] memory personalDataList) {
        require(purposeMap[_id].id != 0, "Purpose does not exist");
        Purpose storage purpose = purposeMap[_id];
        return (purpose.id,purpose.actorId,purpose.dataOwner,purpose.operation,purpose.serviceName,purpose.servicePurpose,purpose.personalDataList);
    }
}
