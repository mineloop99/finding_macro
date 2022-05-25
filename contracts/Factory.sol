//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC1155Token.sol";
import "./ERC721Token.sol";

contract Factory {
    ERC721Token[] public erc721Tokens; //an array that contains different ERC1155 tokens deployed
    ERC1155Token[] public erc1155tokens; //an array that contains different ERC1155 tokens deployed
    mapping(uint256 => address) public erc721IndexToContract; //index to contract address mapping
    mapping(uint256 => address) public erc721IndexToOwner; //index to ERC1155 owner address
    mapping(uint256 => address) public erc1155IndexToContract; //index to contract address mapping
    mapping(uint256 => address) public erc1155IndexToOwner; //index to ERC1155 owner address

    event ERC721Created(address owner, address tokenContract); //emitted when ERC721 token is deployed
    event ERC721Minted(address owner, address tokenContract, uint256 amount); //emmited when ERC721 token is minted
    event ERC1155Created(address owner, address tokenContract); //emitted when ERC1155 token is deployed
    event ERC1155Minted(address owner, address tokenContract, uint256 amount); //emmited when ERC1155 token is minted

    /*
    deployERC721 - deploys a ERC721 token with given parameters - returns deployed address

    _contractName - name of our ERC721 token
    _uri - URI resolving to our hosted metadata
    _ids - IDs the ERC721 token should contain
    _name - Names each ID should map to. Case-sensitive.
    */
    function deployERC721(string[] memory _names, uint256[] memory _ids)
        public
        returns (address)
    {
        ERC721Token t = new ERC721Token(_names, _ids);
        erc721Tokens.push(t);
        erc721IndexToContract[erc721Tokens.length - 1] = address(t);
        erc721IndexToOwner[erc721Tokens.length - 1] = tx.origin;
        emit ERC721Created(msg.sender, address(t));
        return address(t);
    }

    /*
    deployERC1155 - deploys a ERC1155 token with given parameters - returns deployed address

    _contractName - name of our ERC1155 token
    _uri - URI resolving to our hosted metadata
    _ids - IDs the ERC1155 token should contain
    _name - Names each ID should map to. Case-sensitive.
    */
    function deployERC1155(
        string memory _contractName,
        string memory _uri,
        uint256[] memory _ids,
        string[] memory _names
    ) public returns (address) {
        ERC1155Token t = new ERC1155Token(_contractName, _uri, _names, _ids);
        erc1155tokens.push(t);
        erc1155IndexToContract[erc1155tokens.length - 1] = address(t);
        erc1155IndexToOwner[erc1155tokens.length - 1] = tx.origin;
        emit ERC1155Created(msg.sender, address(t));
        return address(t);
    }

    /*
    mintERC721 - mints a ERC721 token with given parameters

    _index - index position in our tokens array - represents which ERC721 you want to interact with
    _name - Case-sensitive. Name of the token (this maps to the ID you created when deploying the token)
    _amount - amount of tokens you wish to mint
    */
    function mintERC721(
        uint256 _index,
        string memory _name,
        uint256 amount
    ) public {
        uint256 id = getERC721IdByName(_index, _name);
        erc721Tokens[_index].mint(erc721IndexToOwner[_index], _name);
        emit ERC721Minted(
            erc721Tokens[_index].ownerOf(_index),
            address(erc721Tokens[_index]),
            amount
        );
    }

    /*
    mintERC1155 - mints a ERC1155 token with given parameters

    _index - index position in our tokens array - represents which ERC1155 you want to interact with
    _name - Case-sensitive. Name of the token (this maps to the ID you created when deploying the token)
    _amount - amount of tokens you wish to mint
    */
    function mintERC1155(
        uint256 _index,
        string memory _name,
        uint256 amount
    ) public {
        uint256 id = getERC1155IdByName(_index, _name);
        erc1155tokens[_index].mint(erc1155IndexToOwner[_index], id, amount);
        emit ERC1155Minted(
            erc1155tokens[_index].owner(),
            address(erc1155tokens[_index]),
            amount
        );
    }

    /*
    Helper functions below retrieve contract data given an ID or name and index in the tokens array.
    */
    function getCountERC721byIndex(uint256 _index)
        public
        view
        returns (uint256 amount)
    {
        return erc721Tokens[_index].balanceOf(erc721IndexToOwner[_index]);
    }

    function getCountERC721byName(uint256 _index, string calldata _name)
        public
        view
        returns (uint256 amount)
    {
        uint256 id = getERC721IdByName(_index, _name);
        return erc721Tokens[_index].balanceOf(erc721IndexToOwner[_index]);
    }

    function getERC721IdByName(uint256 _index, string memory _name)
        public
        view
        returns (uint256)
    {
        return erc721Tokens[_index].nameToId(_name);
    }

    function getERC721NameById(uint256 _index, uint256 _id)
        public
        view
        returns (string memory)
    {
        return erc721Tokens[_index].idToName(_id);
    }

    function getERC721byIndexAndId(uint256 _index, uint256 _id)
        public
        view
        returns (
            address _contract,
            address _owner,
            string memory _uri,
            uint256 supply
        )
    {
        ERC721Token token = erc721Tokens[_id];
        return (
            address(token),
            token.owner(),
            token.tokenURI(_id),
            token.balanceOf(erc721IndexToOwner[_id])
        );
    }

    /*
    Helper functions below retrieve contract data given an ID or name and index in the tokens array.
    */
    function getCountERC1155byIndex(uint256 _index, uint256 _id)
        public
        view
        returns (uint256 amount)
    {
        return
            erc1155tokens[_index].balanceOf(erc1155IndexToOwner[_index], _id);
    }

    function getCountERC1155byName(uint256 _index, string calldata _name)
        public
        view
        returns (uint256 amount)
    {
        uint256 id = getERC1155IdByName(_index, _name);
        return erc1155tokens[_index].balanceOf(erc1155IndexToOwner[_index], id);
    }

    function getERC1155IdByName(uint256 _index, string memory _name)
        public
        view
        returns (uint256)
    {
        return erc1155tokens[_index].nameToId(_name);
    }

    function getERC1155NameById(uint256 _index, uint256 _id)
        public
        view
        returns (string memory)
    {
        return erc1155tokens[_index].idToName(_id);
    }

    function getERC1155byIndexAndId(uint256 _index, uint256 _id)
        public
        view
        returns (
            address _contract,
            address _owner,
            string memory _uri,
            uint256 supply
        )
    {
        ERC1155Token token = erc1155tokens[_index];
        return (
            address(token),
            token.owner(),
            token.uri(_id),
            token.balanceOf(erc1155IndexToOwner[_index], _id)
        );
    }
}
