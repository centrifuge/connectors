// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.7.6;

interface MemberlistLike {
    function updateMember(address usr, uint validUntil) external;
}

contract Memberlist {

  mapping(address => uint256) public wards;

    uint constant minimumDelay = 7 days;

    modifier auth {
        require(wards[msg.sender] == 1, "not-authorized");
        _;
    }

    // --- Math ---
    function safeAdd(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-add-overflow");
    }

    // -- Members--
    mapping (address => uint) public members;
    function updateMember(address usr, uint validUntil) public auth {
        require((safeAdd(block.timestamp, minimumDelay)) < validUntil);
        members[usr] = validUntil;
     }

    function updateMembers(address[] memory users, uint validUntil) public auth {
        for (uint i = 0; i < users.length; i++) {
            updateMember(users[i], validUntil);
        }
    }

    constructor() {
        wards[msg.sender] = 1;
    }

    function member(address usr) public view {
        require((members[usr] >= block.timestamp), "not-allowed-to-hold-token");
    }

    function hasMember(address usr) public view returns (bool) {
        if (members[usr] >= block.timestamp) {
            return true;
        } 
        return false;
    }
}