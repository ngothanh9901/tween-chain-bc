// SPDX-License-Identifier: MIT ERC721
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./interfaces/ICompanyFactory.sol";

contract NFTReward is Initializable, ERC721Upgradeable {
    using Counters for Counters.Counter;

    address public owner;
    string public uri;

    Counters.Counter private _tokenIds;

    modifier onlyOwner() {
        require(owner == tx.origin, "Ownable: caller is not the owner");
        _;
    }

    function initialize() external initializer {
        (
            address admin,
            string memory name,
            string memory symbol,
            string memory baseURI
        ) = ICompanyFactory(msg.sender).getNFTRewardParameters();
        __ERC721_init(name, symbol);
        uri = baseURI;
        owner = admin;
    }

    function safeMint(address to) public onlyOwner {
        _safeMint(to, _tokenIds.current());
        _tokenIds.increment();
    }

    function safeMintBatch(address to, uint8 amount) public onlyOwner {
        for (uint8 idx = 0; idx < amount; idx++) {
            _safeMint(to, _tokenIds.current());
            _tokenIds.increment();
        }
    }

    function burn(uint256 tokenId) public onlyOwner {
        require(msg.sender == ERC721Upgradeable.ownerOf(tokenId), "Not own token");
        _burn(tokenId);
    }

    function burnBatch(uint256[] memory tokenIds) public onlyOwner {
        for (uint256 idx = 0; idx < tokenIds.length; idx++) {
            require(msg.sender == ERC721Upgradeable.ownerOf(tokenIds[idx]), "Not own token");
            _burn(tokenIds[idx]);
        }
    }

    function _baseURI() internal view override returns (string memory) {
        return uri;
    }

    function transferBatch(uint256[] memory tokenIds, address[] memory receivers) public onlyOwner {
        require(tokenIds.length == receivers.length, "Invalid input");
        for (uint256 idx = 0; idx < tokenIds.length; idx++) {
            require(msg.sender == ERC721Upgradeable.ownerOf(tokenIds[idx]), "Not own token");
            _safeTransfer(msg.sender, receivers[idx], tokenIds[idx], "");
        }
    }
}
