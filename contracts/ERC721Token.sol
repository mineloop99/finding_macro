// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC721Token is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string[] public names; //string array of names
    uint256[] public ids; //uint array of ids
    uint256 public mintFee = 0 wei;

    mapping(string => uint256) public nameToId; //name to id mapping
    mapping(uint256 => string) public idToName; //id to name mapping

    constructor(
        string memory _contractName,
        string memory _symbol,
        string[] memory _names,
        uint256[] memory _ids
    ) ERC721(_contractName, _symbol) {
        names = _names;
        ids = _ids;
        createMapping();
    }

    /*
    creates a mapping of strings to ids (i.e ["one","two"], [1,2] - "one" maps to 1, vice versa.)
    */
    function createMapping() private {
        for (uint256 id = 0; id < ids.length; id++) {
            nameToId[names[id]] = ids[id];
            idToName[ids[id]] = names[id];
        }
    }

    function mint(address account, string memory _uri)
        public
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(account, newItemId);
        _setTokenURI(newItemId, _uri);
        _tokenIds.increment();
        return newItemId;
    }
}
