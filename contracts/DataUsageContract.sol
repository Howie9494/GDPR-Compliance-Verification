// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
该代码实现了一个数据使用合约，用于记录行为人的信息，具体实现如下：

1、定义一个结构体 Actor，用于记录行为人的信息，包括行为人ID、服务名称、服务目的、操作以及个人数据列表。
2、使用 mapping 存储所有行为人的信息，以行为人ID为索引。
3、实现了添加新的行为人信息的方法 addActor，用于将新的行为人信息存储在 actorMap 中，添加时需要保证行为人ID不存在。
4、实现了获取指定行为人的信息的方法 getActor，用于返回指定行为人的详细信息。
5、实现了一个私有方法 actorExists，用于检查指定ID的行为人是否存在。

*/
import "./enum.sol";
    
contract DataUsageContract {
    // 行为人结构体，用于记录行为人的信息
    struct Actor {
        bytes32 id ; //
        address actorId; // 行为人地址作为id
        string serviceName; // 服务名称
        string servicePurpose; // 服务目的
        Operator operation; // 操作  “read”, “write” and “transfer”
        string[] personalDataList; // 个人数据列表
    }

    // 使用 mapping 存储所有行为人的信息，以ID为索引
    mapping(bytes32 => Actor) private actorMap;

    // 添加新的行为人信息
    function addActor(string memory _serviceName, string memory _servicePurpose, Operator _operation, string[] memory _personalDataList) public returns(bytes32) {
        //require(!actorExists(_actorId), "Actor already exists");
        // 拼接 actorId ，serviceName，servicePurpose，operation
        address actorId = msg.sender;
        bytes32 id = keccak256(abi.encode(actorId, _serviceName, _servicePurpose, _operation));
        actorMap[id] = Actor(id, actorId, _serviceName, _servicePurpose, _operation, _personalDataList);
        return id;
    }

    // 获取指定行为人的信息
    function getActor(bytes32 _id) public view returns (Operator, string[] memory) {
        require(actorExists(_id), "Actor does not exist");
        Actor memory actor = actorMap[_id];
        return (actor.operation, actor.personalDataList);
    }

    // 检查指定ID的行为人是否存在
    function actorExists(bytes32 _id) private view returns (bool) {
        return actorMap[_id].id != 0;
    }
}
