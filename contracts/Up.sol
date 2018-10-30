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

    // function depositToken(uint256 length) public{


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

    //TODO code to verify owner (save creator address). is this really needed???
    function withdraw() public {
        if (now > endTime) { //TODO change to require
            ownerAddress.transfer(address(this).balance);
            //send back money
        }
        emit Withdraw();
        //TODO contract suicide TODO test contract suicide
        //check that balance of the contract is 0 and suicide?
    }

    //TODO TEST THIS
    //TODO add function in
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
    mapping (address => address) ups;
    event PactCreated(address _address);

    //TODO test
    function createPact() public {
        if (ups[msg.sender] == 0) { //one contract per person
            //TODO fire event
            ups[msg.sender] = new Up();

            emit PactCreated(ups[msg.sender]);
            //TODO roll the deposit in with the creation?
        }
    }

    function deposit(uint256 amount, uint256 length) payable public {
        require(ups[msg.sender] != 0);
        Up(ups[msg.sender]).deposit(amount, length);
    }

    function withdraw() public {
        require(ups[msg.sender] != 0);
        Up(ups[msg.sender]).withdraw();
    }
}
