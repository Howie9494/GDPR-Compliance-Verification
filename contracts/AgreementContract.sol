// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//“hash address of a purpose block”, “user ID” and “positive/negative consent”

contract AgreementContract {
    struct Vote {
        bytes32 id; //唯一键 
        address hashAddress; // 意图块的哈希地址
        address userId; // 用户ID
        address actorAddress; // 行为人地址
        bool userConsent; // 是否为积极同意
    }

    mapping(bytes32 => Vote) private voteMap; // 存储投票的映射

    function vote(bytes32 _id,address _hashAddress,address _userId,address _actorAddress,bool _userConsent) public {
        require(voteMap[_id].id == 0,"The user has already voted."); // 确认用户没有重复投票

        voteMap[_id] = Vote(_id,_hashAddress,_userId,_actorAddress,_userConsent); // 存储投票
    }

    function getVote(bytes32 _id) public view returns (address,bool){
        Vote storage vt = voteMap[_id];
        return (vt.actorAddress,vt.userConsent); // 返回投票信息及行为人地址
    }

    //判断用户同意结果
    function isActorAuthorized(bytes32 _id) public view returns (bool){
        return voteMap[_id].userConsent;
    }

}
