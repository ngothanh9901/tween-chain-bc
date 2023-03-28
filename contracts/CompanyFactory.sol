// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interfaces/ICompanyFactory.sol";
import "./libraries/Clones.sol";
import "./Membership.sol";
import "./NFTReward.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CompanyFactory is ICompanyFactory, AccessControl {
    bytes32 public constant MOD = keccak256("MOD");
    bytes32 public constant ADMIN = keccak256("ADMIN");

    NFTReward public nftImpl;
    Membership public membershipImpl;

    NFTRewardParams public nftParameters;
    MembershipParams public membershipParameters;

    address public override signerAddress;

    function getNFTRewardParameters()
        external
        view
        override
        returns (
            address admin,
            string memory name,
            string memory symbol,
            string memory baseURI
        )
    {
        NFTRewardParams memory nftRewardParam = nftParameters;
        return (
            nftRewardParam.admin,
            nftRewardParam.name,
            nftRewardParam.symbol,
            nftRewardParam.baseURI
        );
    }

    function getMembershipParameters()
        external
        view
        override
        returns (
            string memory name,
            string memory symbol,
            address admin,
            address nftContract
        ) {
        MembershipParams memory membershipParam = membershipParameters;
        return (
            membershipParam.name,
            membershipParam.symbol,
            membershipParam.admin,
            membershipParam.nftContract
        );
    }

    constructor(NFTReward _nftImpl, Membership _membershipImpl) {
        _setRoleAdmin(MOD, ADMIN);
        _setRoleAdmin(ADMIN, ADMIN);
        _setupRole(ADMIN, msg.sender);
        _setupRole(MOD, msg.sender);

        nftImpl = _nftImpl;
        membershipImpl = _membershipImpl;
        signerAddress = msg.sender;
    }

    function changeNftImpl(NFTReward _nftImpl) external {
        require(
            hasRole(ADMIN, msg.sender),
            "CompanyFactory: require ADMIN role"
        );
        nftImpl = _nftImpl;

        emit ChangeNFTRewardImpl(address(_nftImpl));
    }

    function changeMembershipImpl(Membership _membershipImpl) external {
        require(
            hasRole(ADMIN, msg.sender),
            "CompanyFactory: require ADMIN role"
        );
        membershipImpl = _membershipImpl;

        emit ChangeMembershipImpl(address(_membershipImpl));
    }

    function createNftReward(
        address _admin,
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) external returns (address nftRewardAddress) {
        require(
            hasRole(ADMIN, msg.sender),
            "CompanyFactory: require ADMIN role"
        );

        nftRewardAddress = _deployNftReward(_admin, _name, _symbol, _baseURI);

        emit NFTRewardCreated(nftRewardAddress);
    }

    function createMembership(
        string memory _name,
        string memory _symbol,
        address _admin,
        address _nftContract
    ) external returns (address membershipAddress) {
        require(hasRole(ADMIN, msg.sender), "CompanyFactory: require ADMIN role");

        membershipAddress = _deployMembership(
            _name,
            _symbol,
            _admin,
            _nftContract
        );

        emit MembershipCreated(membershipAddress);
    }

    function _deployNftReward(
        address _admin,
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) private returns (address nftRewardAddress) {
        nftParameters = NFTRewardParams({
            admin: _admin,
            name: _name,
            symbol: _symbol,
            baseURI: _baseURI
        });

        nftRewardAddress = Clones.clone(address(nftImpl));

        NFTReward(nftRewardAddress).initialize();

        delete nftParameters;
    }

    function _deployMembership(
        string memory _name,
        string memory _symbol,
        address _admin,
        address _nftContract
    ) private returns (address membershipAddress) {
        membershipParameters = MembershipParams({
            name: _name,
            symbol: _symbol,
            admin: _admin,
            nftContract: _nftContract
        });

        membershipAddress = Clones.clone(address(membershipImpl));

        Membership(membershipAddress).initialize();

        delete membershipParameters;
    }

    // function changeSigner(address _newSigner) external {
    //     require(hasRole(ADMIN, msg.sender), "CompanyFactory: require ADMIN role");
    //     signerAddress = _newSigner;
    //     emit ChangeSigner(_newSigner);
    // }
}
