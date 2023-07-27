// SPDX-License-Identifier: CC0-1.0
pragma solidity 0.8.15;

import "./DD.sol";

contract Pool {
    uint256 nonce;
    DD public immutable direct_deposit_queue;

    event Message(uint256 indexed index, bytes32 indexed hash, bytes message);

    uint256 constant uint256_size = 32;

    function _loaduint256(uint256 pos) internal pure returns (uint256 r) {
        assembly {
            r := calldataload(pos)
        }
    }

    uint256 constant tx_type_pos = 640;
    uint256 constant tx_type_size = 2;
    uint256 constant tx_type_mask = (1 << (tx_type_size * 8)) - 1;

    function _tx_type() internal pure returns (uint256 r) {
        r = _loaduint256(tx_type_pos + tx_type_size - uint256_size) & tx_type_mask;
    }

    uint256 constant memo_data_size_pos = tx_type_pos + tx_type_size;
    uint256 constant memo_data_size_size = 2;
    uint256 constant memo_data_size_mask = (1 << (memo_data_size_size * 8)) - 1;

    function _memo_data_size() internal pure returns (uint256 r) {
        r = _loaduint256(memo_data_size_pos + memo_data_size_size - uint256_size) & memo_data_size_mask;
    }

    uint256 constant memo_data_pos = memo_data_size_pos + memo_data_size_size;

    function _memo_fixed_size() internal pure returns (uint256 r) {
        uint256 t = _tx_type();
        if (t == 0 || t == 1) {
            // fee
            // 8
            r = 8;
        } else if (t == 2) {
            // fee + native amount + recipient
            // 8 + 8 + 20
            r = 36;
        } else if (t == 3) {
            // fee + deadline + address
            // 8 + 8 + 20
            r = 36;
        } else {
            revert();
        }
    }

    function _memo_message() internal pure returns (bytes calldata r) {
        uint256 memo_fixed_size = _memo_fixed_size();
        uint256 offset = memo_data_pos + memo_fixed_size;
        uint256 length = _memo_data_size() - memo_fixed_size;
        assembly {
            r.offset := offset
            r.length := length
        }
    }

    constructor(address _direct_deposit_queue)
    {
        direct_deposit_queue = DD(_direct_deposit_queue);
    }

    function transact() external
    {
        // bytes memory m = new bytes(10);
        nonce = nonce + 128;
        bytes32 h = keccak256(abi.encode(nonce));

        bytes memory m;
        if (msg.data.length > 4) {
            m = _memo_message();
        } else {
            m = new bytes(10);
        }

        emit Message(nonce, h, m);
    }

    function appendDirectDeposits(
        uint256 _root_after,
        uint256[] calldata _indices,
        uint256 _out_commit,
        uint256[8] memory _batch_deposit_proof,
        uint256[8] memory _tree_proof
    ) external {
        nonce = nonce + 128;
        bytes32 h = keccak256(abi.encode(nonce));

        bytes memory m = direct_deposit_queue.completeDD(_indices);

        emit Message(nonce, h, m);
    }

}