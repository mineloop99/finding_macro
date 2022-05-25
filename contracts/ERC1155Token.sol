//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Token is ERC1155, Ownable {
    string public baseMetadataURI; //the token metadata URI
    string public name; //the token mame
    uint256 public mintFee = 0 wei; //mintfee, 0 by default. only used in mint function, not batch.

    mapping(string => uint256) public nameToId; //name to id mapping
    mapping(uint256 => string) public idToName; //id to name mapping

    /*
    constructor is executed when the factory contract calls its own deployERC1155 method
    */
    constructor(string memory _contractName, string memory _uri) ERC1155(_uri) {
        setURI(_uri);
        baseMetadataURI = _uri;
        name = _contractName;
        transferOwnership(tx.origin);
    }

    /*
    sets our URI and makes the ERC1155 OpenSea compatible
    */
    function uri(uint256 _tokenid)
        public
        view
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    baseMetadataURI,
                    Strings.toString(_tokenid),
                    ".json"
                )
            );
    }

    /*
    used to change metadata, only owner access
    */
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /*
    set a mint fee. only used for mint, not batch.
    */
    function setFee(uint256 _fee) public onlyOwner {
        mintFee = _fee;
    }

    /*
    mint(address account, uint _id, uint256 amount)

    account - address to mint the token to
    _id - the ID being minted
    amount - amount of tokens to mint
    */
    function mint(
        address account,
        uint256 _id,
        uint256 amount
    ) public payable returns (uint256) {
        require(msg.value == mintFee);
        _mint(account, _id, amount, "");
        return _id;
    }

    /*
    mintBatch(address to, uint256[] memory _ids, uint256[] memory amounts, bytes memory data)

    to - address to mint the token to
    _ids - the IDs being minted
    amounts - amount of tokens to mint given ID
    bytes - additional field to pass data to function
    */
    function mintBatch(
        address to,
        uint256[] memory _ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        _mintBatch(to, _ids, amounts, data);
    }
}
