// SPDX-License-Identifier: CC0-1.0
pragma solidity 0.8.15;

contract Pool {
    uint256 nonce;
    event Message(uint256 indexed index, bytes32 indexed hash, bytes message);

    function transact() external
    {
        bytes memory m = new bytes(10);
        uint256 index = nonce++;
        bytes32 h = keccak256(abi.encode(index));

        emit Message(index, h, m);
    }
}