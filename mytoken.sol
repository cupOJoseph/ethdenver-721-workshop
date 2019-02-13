pragma solidity ^0.5.0;

//npm install openzeppelin-solidity
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC721{
  address owner;
  uint total_mons = 0;

  struct Pokemon{
    uint id;
    uint attack;
    uint health;
    string image_url;
  }

  mapping (uint => Pokemon) pokemon_list;
  mapping (uint => address) id_to_owner;

  constructor() public {
    owner = msg.sender;//0xabc123
    //give token 0 the owner;
    Pokemon memory instance = Pokemon(total_mons, 100, 100, "example.com/0");
    pokemon_list[total_mons] = instance;
    _mint(owner, total_mons);
    id_to_owner[0] = owner;
    total_mons++;
  }

  function sendPokemon(uint tokenId, address to) public {
    require(msg.sender == id_to_owner[tokenId]);

    //_safeTransferFrom(_to, from, id )
    _safeTransferFrom(to, id_to_owner[tokenId], tokenId);
    id_to_owner[tokenId] = to;//set new owner
  }

  // uint attack;
  // uint health;
  // string image_url;
  function createAPokemon(uint _attack, uint _health, string _image_url) public payable{
    require(_attack < 100);
    require(_health > 0);

    //msg.value
    require(msg.value >= 0.005);//fee is .005 ETH

    Pokemon memory instance = Pokemon(total_mons, _attack, _health, _image_url);
    pokemon_list[total_mons] = instance;
    _mint(msg.sender, total_mons);
    id_to_owner[total_mons] = msg.sender;
    total_mons++;
  }

  function cashout(address payable _payto) public {
    require(msg.sender == owner);
    _payto.transfer(address(this).balance);
  }
}
