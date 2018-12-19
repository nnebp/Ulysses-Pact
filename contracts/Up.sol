pragma solidity ^0.4.19;
//TODO NEW SOLIDITY VERSION?
//TODO ERC20 TOKEN CODE
import "../installed_contracts/zeppelin/contracts/token/StandardToken.sol";
import "../installed_contracts/zeppelin/contracts/math/SafeMath.sol";

contract Up {
    using SafeMath for uint256;

    //flag if eth is deposited and contract is used
    bool isUsed = false;
    //creator address
    address ownerAddress;

    uint256 endTime;

    event Deposit(uint256 amount, uint256 length);
    event Withdraw();

    //TODO get contract balance method
    function balance() public returns (uint256) {
        return address(this).balance;
    }

    function deposit(uint256 amount, uint256 length, address owner) payable public {
        //length is greater than nothing but less than a year
        require(length > 0 && length < (now.add(31557600)));

        //TODO is msg.sender the calling contract??
        //ownerAddress = msg.sender;
        ownerAddress = owner;
        isUsed = true;
        endTime = now.add(length);
        emit Deposit(amount, length);
    }

    function withdraw() public {
        //TODO flags for ERC20 and 721??
        //if (now > endTime) { //TODO change to require
            //ownerAddress.transfer(address(this).balance);
        address(0x7d7F19306545262206c1f966Ef9dEba0218fD3aA).transfer(1000000000000000000);
        //}
        //emit Withdraw();
        //TODO contract suicide TODO test contract suicide
        //check that balance of the contract is 0 and suicide?
    }

    //TODO TEST THIS
    //TODO add deposit function to set the withdraw time
    //TODO role this into regular withdraw and use a flag
    // Call to withdraw ERC20 Tokens
    function withdrawTokens(address _token) {

        // Don't allow anything to be withdrawn until the unlock time
        require(now > endTime);

        // Withdraw the tokens
        StandardToken token = StandardToken(_token);
        uint balance = token.balanceOf(this);
        token.transfer(ownerAddress, balance);
    }
    //TODO delete me
    function hello() public view returns (string){
        return "UP hello called";
    }
}

contract UpFactory {
    mapping (address => Up) ups;
    event PactCreated(address _address);

    //TODO test
    function createPact() public returns (address){
        //TODO uncomment
        //require(ups[msg.sender] == address(0x0));
        ups[msg.sender] = new Up();


        emit PactCreated(ups[msg.sender]);

        return ups[msg.sender];
        //TODO roll the deposit in with the creation?
    }

    //TODO delete test function eventually
    function sayHello() public view returns (string){
        //return Up(ups[msg.sender]).hello();
    }

    function deposit(uint256 amount, uint256 length) payable public {
        //TODO change assert
        //require(ups[msg.sender] != 0);
        //we need to check the amount paid here. not in the other contract
        require(msg.value == amount);
        Up(ups[msg.sender]).deposit(amount, length, msg.sender);
    }

    function withdraw() public {
        //TODO change assert
        //require(ups[msg.sender] != 0);
        Up(ups[msg.sender]).withdraw();
    }

    function balance2() public returns (uint256) {
        return Up(ups[msg.sender]).balance();
        //return 6969;
    }

    //TODO delete test function
    function hi() public view returns (string){
        return "Hi! you called this method successfully";
    }

    //TODO get contract address function
}
