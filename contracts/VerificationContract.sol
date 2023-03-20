// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./AgreementContract.sol";
import "./LogContract.sol";
import "./DataUsageContract.sol";
import "./enum.sol";

/**
 * @title VerificationContract
 * @notice This contract verifies user behavior against agreements, data usage contracts, and logs.
 * It contains methods to verify a user action and compare personal data with processed data.
 * The contract uses mappings to associate personal data with a bit map and to clear the mapping after use.
 */
contract VerificationContract {

    // AgreementContract instance to retrieve agreement information
    AgreementContract private agreementContract;
    // LogContract instance to retrieve log information
    LogContract private logContract;
    // DataUsageContract instance to retrieve data usage terms
    DataUsageContract private dataUsageContract;
    // Flag to prevent re-entrancy attacks
    bool private locked = false;
    // Mapping used to initialize a new mapping in the MappingCompare function
    mapping(string => uint8) emptyMapping;

    /**
     * @notice Constructor function to set the contract's instances of AgreementContract, LogContract, and DataUsageContract.
     * @param _agreementContract Address of AgreementContract.
     * @param _logContract Address of LogContract.
     * @param _dataUsageContract Address of DataUsageContract.
     */
    constructor(address _agreementContract, address _logContract, address _dataUsageContract) {
        agreementContract = AgreementContract(_agreementContract);
        logContract = LogContract(_logContract);
        dataUsageContract = DataUsageContract(_dataUsageContract);
    }

    /**
     * @notice Verifies user behavior against agreements, data usage contracts, and logs.
     * @param _logId The log ID to verify.
     * @return actorId The address of the actor that has invalid behavior, or 0 if the behavior is valid.
     */
    function verify(uint _logId) public returns(address actorId) {
        require(!locked);
        locked = true;
        // get log information
        (address logActorId,Operator logOperation, string[] memory processedData,bytes32 contractId) = logContract.getLog(_logId);
        // get agreement information
        (address agreementActorAddress,bool userConsent) = agreementContract.getVote(contractId);
        // get data usage information
        (Operator dataUseOperation, string[] memory personalDataList) = dataUsageContract.getPurpose(contractId);
        locked = false;

        if (agreementActorAddress != logActorId) {
            return logActorId;
        }

        // Check if the logged operation is compliant with the data usage contract and if the user has given consent
        if ((dataUseOperation != logOperation) || (!userConsent)) {
            return logActorId;
        } 

        if(personalDataList.length != processedData.length){
            return logActorId;
        }

        // Check if personal data has been verified
        if(personalDataList.length <= 59){
            if (!LoopCompare(personalDataList,processedData)) {
                return logActorId;
            }
        }else{
            if (!MappingCompare(personalDataList,processedData)) {
                return logActorId;
            }
        }

        return address(0);
    }

    /**
    * @notice Compares two lists of strings using loops.
    * This function should only be used for lists with a length of 256 or less.
    * @param personalDataList The list of personal data.
    * @param processedData The list of processed data.
    * @return flag True if the lists are equal, false otherwise.
    */
    function LoopCompare(string[] memory personalDataList, string[] memory processedData) internal pure returns(bool flag) {
        require(personalDataList.length <= 256);
        uint length = personalDataList.length;
        uint bitMap = 0;
        bytes32[] memory personalDataBytes = new bytes32[](length);
        bytes32[] memory processedDataBytes = new bytes32[](length);
        for (uint i = 0; i < length; i++) {
            personalDataBytes[i] = keccak256(abi.encodePacked(personalDataList[i]));
            processedDataBytes[i] = keccak256(abi.encodePacked(processedData[i]));
        }
        for (uint i = 0; i < processedData.length; i++) {
            flag = false;
            for (uint j = 0; j < personalDataList.length; j++) {
                if (personalDataBytes[i] == processedDataBytes[j] && (bitMap & (1 << j)) == 0) {
                    bitMap = bitMap | (1 << j);
                    flag = true;
                    break;
                }
            }
            if (!flag) {
                return false;
            }
            flag = false;
        }
        return true;
    }

    /**
    * @notice Compares two lists of strings using a mapping.
    * @param personalDataList The list of personal data.
    * @param processedData The list of processed data.
    * @return flag True if the lists are equal, false otherwise.
    */
    function MappingCompare(string[] memory personalDataList, string[] memory processedData) internal returns(bool flag) {
        mapping(string => uint8) storage listMap = emptyMapping;
        for (uint i = 0; i < personalDataList.length; i++) {
            listMap[personalDataList[i]] += 1;
        }
        for (uint i = 0; i < processedData.length; i++) {
            if (listMap[processedData[i]] == 0) {
                clearMapping(listMap, personalDataList);
                return false;
            }
            listMap[processedData[i]] -= 1;
        }
        clearMapping(listMap, personalDataList);
        return true;
    }

    /**
    * @notice Clears a mapping of string to uint8.
    * @param listMap The mapping to clear.
    * @param personalDataList The list of personal data used to create the mapping.
    */
    function clearMapping(mapping(string => uint8) storage listMap, string[] memory personalDataList) internal {
        for (uint i = 0; i < personalDataList.length; i++) {
            listMap[personalDataList[i]] = 0;
        }
    }
}