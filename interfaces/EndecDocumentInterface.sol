// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface EndecDocumentInterface {
    function getContractAddress() external view returns (address);
    function getDocumentId() external view returns (string memory);
}
