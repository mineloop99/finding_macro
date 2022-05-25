// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC721Token is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public mintFee = 0 wei;
    event AwardNewItem(uint256 indexed newID);

    constructor(string memory _contractName, string memory _symbol)
        ERC721(_contractName, _symbol)
    {}

    function mint(address account, string memory _uri)
        public
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(account, newItemId);
        _setTokenURI(newItemId, _uri);
        _tokenIds.increment();
        emit AwardNewItem(newItemId);
        return newItemId;
    }
}
