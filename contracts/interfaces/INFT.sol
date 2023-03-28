// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface INFT {
    function getPoints(uint256 tokenId) external returns (uint256);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}
