// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./interfaces/ICompanyFactory.sol";
import "./interfaces/INFT.sol";

contract Membership is Initializable {
    string public _name;
    string public _symbol;
    address public owner;
    address public _nftContract;

    // Definition of struct for membership
    struct Membership {
        uint256 memberType;
        uint256 role;
        // bool sex;
        int sex;
        string name;
        uint256 loyaltyPoints;
        string tokenURI;
        bool init;
    }

    // map Membership token id to Membership
    mapping(address => Membership) public memberships;

    function initialize() external initializer {
        (
            string memory name,
            string memory symbol,
            address admin,
            address nftContract
        ) = ICompanyFactory(msg.sender).getMembershipParameters();
        _nftContract = nftContract;
        owner = admin;
        _name = name;
        _symbol = symbol;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function mintMembershipBatch(
        address[] memory _to,
        uint256[] memory _memberType,
        uint256[] memory _role,
        // bool[] memory _sex,
        int[] memory _sex,
        string[] memory _name,
        uint256[] memory _loyaltyPoints,
        string[] memory _tokenURI
    ) public onlyOwner {
        require(_to.length == _memberType.length, "Invalid length");
        require(_memberType.length == _role.length, "Invalid length");
        require(_role.length == _name.length, "Invalid length");
        require(_name.length == _loyaltyPoints.length, "Invalid length");
        require(_loyaltyPoints.length == _tokenURI.length, "Invalid length");

        for (uint256 idx = 0; idx < _to.length; idx++) {
            require(
                memberships[_to[idx]].init == false,
                "Member already exist"
            );
            Membership memory newMembership = Membership(
                _memberType[idx],
                _role[idx],
                _sex[idx],
                _name[idx],
                _loyaltyPoints[idx],
                _tokenURI[idx],
                true
            );
            memberships[_to[idx]] = newMembership;
        }
    }

    function deleteMember(address _to) public onlyOwner {
        require(memberships[_to].init == true, "Member not exist");
        delete memberships[_to];
    }

    function updateStats(
        address _to,
        uint256 _memberType,
        uint256 _role,
        string memory _name,
        uint256 _loyaltyPoints,
        string memory _tokenURI
    ) public onlyOwner {
        Membership storage membership = memberships[_to];

        membership.memberType = _memberType;
        membership.role = _role;
        membership.loyaltyPoints = _loyaltyPoints;
        membership.tokenURI = _tokenURI;
    }

    function updatePoint(uint256[] memory _arrPoint, address[] memory _to)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < _arrPoint.length; i++) {
            Membership storage membership = memberships[_to[i]];
            membership.loyaltyPoints = _arrPoint[i];
        }
    }

    function exchangePointForReward(uint256 tokenId) external {
        Membership storage membership = memberships[msg.sender];
        INFT nftContract = INFT(_nftContract);

        uint256 points = nftContract.getPoints(tokenId);
        require(points <= membership.loyaltyPoints, "Not enough points");
        membership.loyaltyPoints -= points;
        nftContract.safeTransferFrom(owner, msg.sender, tokenId);
    }
}
