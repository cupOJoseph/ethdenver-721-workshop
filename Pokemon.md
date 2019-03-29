pragma solidity ^0.5.0;

//npm install openzeppelin-solidity
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract Pokemon_Game { //this is another comment!
  //this is a comment!
  struct Pokemon{
  	uint health;
  	uint attack;
  	string image_url;
  }

  address contract_deployer;
  uint max_number_of_pokemon;
  uint total_pokemon;

  mapping (uint => address) pokemon_owner;
  mapping (uint => Pokemon) pokemon_list;

  constructor(){
		//what gets set?
    contract_deployer = msg.sender;
    max_number_of_pokemon = 151;
    total_pokemon = 0;
	}

  function trade(address from, address to, uint pokemon_id) {
    //check if from is the owner of this token
    require(from == pokemon_owner[pokemon_id]);
    require(to != address(0));
    pokemon_owner[pokemon_id] = to;
    safeTransferFrom(from, to, pokemon_id);
  }

  function mintPokemon(uint _health, uint _attack, string _image_url) payable {
    //require(msg.sender == contract_deployer); //TODO add a fee for anyone
    require(msg.value == 0.008 ether);

    require(total_pokemon < max_number_of_pokemon);
    require(_attack < 100);
    require(_health > 0);
    total_pokemon = total_pokemon + 1;

    Pokemon memory instance = Pokemon(_health, _attack, _image_url);
    pokemon_list[total_pokemon] = instance;
    _mint(msg.sender, total_pokemon);
    pokemon_owner[total_pokemon] = msg.sender;
  }

  function cashout(address payable _payto) public {
    require(msg.sender == contract_deployer);
    _payto.transfer(address(this).balance);
  }

}
