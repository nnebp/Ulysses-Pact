pragma solidity ^0.4.17;
//TODO NEW SOLIDITY VERSION?
//TODO ERC20 TOKEN CODE
import "../installed_contracts/zeppelin/contracts/token/StandardToken.sol";
contract Up {

    //flag if eth is deposited and contract is used
    bool isUsed = false;
    //creator address
    address ownerAddress;

    uint256 endTime;

    event Deposit(uint256 amount, uint256 length);
    event Withdraw();

    // function depositToken(uint256 length) public{


    //TODO deal with time conversion on front end
    //TODO check for overflows once openzeppelin can be imported
    function deposit(uint256 amount, uint256 length) payable public{
        require(msg.value == amount);
        require(length > 0 && length < 31557600);
        //TODO require lentgh is less than a year

        ownerAddress = msg.sender;
        isUsed = true;
        endTime = now + length;
        emit Deposit(amount, length);
    }

    //TODO code to verify owner (save creator address). is this really needed???
    function withdraw() public{
        if (now > endTime) {
            ownerAddress.transfer(address(this).balance);
            //send back money
        }
        emit Withdraw();
        //TODO contract suicide
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

    function deposit(uint256 amount, uint256 length) payable public{
        require(ups[msg.sender] != 0);
        Up(ups[msg.sender]).deposit(amount, length);
    }

    function withdraw() public{
        require(ups[msg.sender] != 0);
        Up(ups[msg.sender]).withdraw();
    }
}
