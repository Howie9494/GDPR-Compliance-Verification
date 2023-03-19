// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * Enum to represent the types of data operations.
 * It contains three possible values:
 * - READ: Represents a read operation on the data.
 * - WRITE: Represents a write operation on the data.
 * - TRANSFER: Represents a data transfer operation.
 */
enum Operator {READ, WRITE, TRANSFER}
