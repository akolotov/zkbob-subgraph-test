// SPDX-License-Identifier: CC0-1.0

pragma solidity 0.8.15;

/**
 * @title ZkAddress
 * Library for parsing zkBob addresses.
 */
library ZkAddress {
    struct ZkAddress {
        bytes10 diversifier;
        bytes32 pk;
    }
}