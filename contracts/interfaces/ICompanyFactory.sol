// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface ICompanyFactory {

    event NFTRewardCreated(
        address NFTRewardAddress
    );

    event MembershipCreated(
        address MembershipAddress
    );

    event ChangeNFTRewardImpl(
        address NFTRewardImplAddress
    );

    event ChangeMembershipImpl(
        address MembershipImplAddress
    );

    event ChangeSigner(
        address signer
    );

    struct NFTRewardParams {
        address admin;
        string name;
        string symbol;
        string baseURI;
    }

    struct MembershipParams {
        string name;
        string symbol;
        address admin;
        address nftContract;
    }

    function signerAddress() external view returns(address);

    function getNFTRewardParameters()
        external
        returns (
            address admin,
            string memory name,
            string memory symbol,
            string memory baseURI
        );

    function getMembershipParameters()
        external
        returns (
            string memory name,
            string memory symbol,
            address admin,
            address nftContract
        );
}