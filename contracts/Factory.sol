//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC1155Token.sol";
import "./ERC721Token.sol";

interface IERC721Factory {
    event ERC721Created(address owner, address tokenContract); //emitted when ERC721 token is deployed
    event ERC721Minted(address owner, address tokenContract); //emmited when ERC721 token is minted

    function deployERC721(
        string calldata _contractName,
        string calldata _symbol
    ) external returns (address);

    function mintERC721(
        uint256 _index,
        address _owner,
        string memory _name
    ) external;
}

contract ERC721Factory is IERC721Factory {
    ERC721Token[] public erc721Tokens; //an array that contains different ERC1155 tokens deployed
    mapping(uint256 => address) public erc721IndexToContract; //index to contract address mapping
    mapping(uint256 => address) public erc721IndexToOwner; //index to ERC1155 owner address

    /*
    deployERC721 - deploys a ERC721 token with given parameters - returns deployed address

    _contractName - name of our ERC721 token
    _uri - URI resolving to our hosted metadata
    _ids - IDs the ERC721 token should contain
    _name - Names each ID should map to. Case-sensitive.
    */
    function deployERC721(
        string calldata _contractName,
        string calldata _symbol
    ) public override returns (address) {
        ERC721Token t = new ERC721Token(_contractName, _symbol);
        erc721Tokens.push(t);
        erc721IndexToContract[erc721Tokens.length - 1] = address(t);
        erc721IndexToOwner[erc721Tokens.length - 1] = tx.origin;
        emit ERC721Created(msg.sender, address(t));
        return address(t);
    }

    /*
    mintERC721 - mints a ERC721 token with given parameters

    _name - Case-sensitive. Name of the token (this maps to the ID you created when deploying the token)
    _amount - amount of tokens you wish to mint
    */

    function mintERC721(
        uint256 _index,
        address _owner,
        string memory _name
    ) public override {
        erc721Tokens[_index].mint(_owner, _name);
        emit ERC721Minted(_owner, address(erc721Tokens[_index]));
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
        ERC721Token token = erc721Tokens[_index];
        return (
            address(token),
            token.ownerOf(_id),
            token.tokenURI(_id),
            token.balanceOf(erc721IndexToOwner[_id])
        );
    }
}

interface IERC1155Factory {
    event ERC1155Created(address owner, address tokenContract); //emitted when ERC1155 token is deployed
    event ERC1155Minted(
        address owner,
        address tokenContract,
        uint256 indexed amount
    );

    function deployERC1155(string memory _contractName, string memory _uri)
        external
        returns (address);

    function mintERC1155(
        uint256 _index,
        address _owner,
        string memory _name,
        uint256 _amount
    ) external;
}

contract ERC1155Factory is IERC1155Factory {
    ERC1155Token[] public erc1155Tokens; //an array that contains different ERC1155 tokens deployed
    mapping(uint256 => address) public erc1155IndexToContract; //index to contract address mapping
    mapping(uint256 => address) public erc1155IndexToOwner; //index to ERC1155 owner address

    /*
    deployERC1155 - deploys a ERC1155 token with given parameters - returns deployed address

    _contractName - name of our ERC1155 token
    _uri - URI resolving to our hosted metadata
    _ids - IDs the ERC1155 token should contain
    _name - Names each ID should map to. Case-sensitive.
    */
    function deployERC1155(string calldata _contractName, string calldata _uri)
        public
        override
        returns (address)
    {
        ERC1155Token t = new ERC1155Token(_contractName, _uri);
        erc1155Tokens.push(t);
        erc1155IndexToContract[erc1155Tokens.length - 1] = address(t);
        erc1155IndexToOwner[erc1155Tokens.length - 1] = tx.origin;
        emit ERC1155Created(msg.sender, address(t));
        return address(t);
    }

    /*
    mintERC1155 - mints a ERC1155 token with given parameters

    _index - index position in our tokens array - represents which ERC1155 you want to interact with
    _name - Case-sensitive. Name of the token (this maps to the ID you created when deploying the token)
    _amount - amount of tokens you wish to mint
    */
    function mintERC1155(
        uint256 _index,
        address _owner,
        string memory _name,
        uint256 _amount
    ) public override {
        erc1155Tokens[_index].mint(
            _owner,
            erc1155Tokens[_index].nameToId(_name),
            _amount
        );
        emit ERC1155Minted(_owner, address(erc1155Tokens[_index]), _amount);
    }

    function getCountERC1155byName(uint256 _index, string calldata _name)
        public
        view
        returns (uint256 amount)
    {
        uint256 id = getERC1155IdByName(_index, _name);
        return erc1155Tokens[_index].balanceOf(erc1155IndexToOwner[_index], id);
    }

    function getERC1155IdByName(uint256 _index, string memory _name)
        public
        view
        returns (uint256)
    {
        return erc1155Tokens[_index].nameToId(_name);
    }

    function getERC1155NameById(uint256 _index, uint256 _id)
        public
        view
        returns (string memory)
    {
        return erc1155Tokens[_index].idToName(_id);
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
        ERC1155Token token = erc1155Tokens[_index];
        return (
            address(token),
            token.owner(),
            token.uri(_id),
            token.balanceOf(erc1155IndexToOwner[_index], _id)
        );
    }
}

contract Factory is Ownable {
    IERC721Factory public immutable erc721Factory;
    IERC1155Factory public immutable erc1155Factory;

    constructor() {
        erc721Factory = IERC721Factory(address(new ERC721Factory()));
        erc1155Factory = IERC1155Factory(address(new ERC1155Factory()));
    }

    function deployERC721(
        string calldata _contractName,
        string calldata _symbol
    ) public onlyOwner {
        erc721Factory.deployERC721(_contractName, _symbol);
    }

    function mintERC721(
        uint256 _index,
        address _owner,
        string memory _name
    ) public onlyOwner {
        erc721Factory.mintERC721(_index, _owner, _name);
    }

    function deployERC1155(string calldata _contractName, string calldata _uri)
        public
        onlyOwner
    {
        erc1155Factory.deployERC1155(_contractName, _uri);
    }

    function mintERC1155(
        uint256 _index,
        address _owner,
        string memory _name,
        uint256 _amount
    ) public onlyOwner {
        erc1155Factory.mintERC1155(_index, _owner, _name, _amount);
    }
}
