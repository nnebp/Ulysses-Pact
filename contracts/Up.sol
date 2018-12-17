pragma solidity ^0.4.17;
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

    //TODO deal with time conversion on front end
    function deposit(uint256 amount, uint256 length) payable public {
        require(msg.value == amount);
        //length is greater than nothing but less than a year
        require(length > 0 && length < (now.add(31557600)));

        ownerAddress = msg.sender;
        isUsed = true;
        endTime = now.add(length);
        emit Deposit(amount, length);
    }

    function withdraw() public {
        //TODO flags for ERC20 and 721??
        if (now > endTime) { //TODO change to require
            ownerAddress.transfer(address(this).balance);
            //send back money
        }
        emit Withdraw();
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
}

contract UpFactory {
    //mapping (address => address) ups;
    mapping (address => Up) ups;
    event PactCreated(address _address);
    //TODO delete
    address deleteMe;

    //TODO test
    function createPact() public returns (address){
        //TODO add in require
        ups[msg.sender] = new Up();


        emit PactCreated(ups[msg.sender]);

        return ups[msg.sender];//TODO read this from the event
        //TODO roll the deposit in with the creation?
    }

    function deposit(uint256 amount, uint256 length) payable public {
        //TODO change assert
        //require(ups[msg.sender] != 0);
        Up(ups[msg.sender]).deposit(amount, length);
    }

    function withdraw() public {
        //TODO change assert
        //require(ups[msg.sender] != 0);
        Up(ups[msg.sender]).withdraw();
    }

    //TODO delete test function
    function hi() public view returns (string){
        return "Hi! you called this method successfully";
    }
}
