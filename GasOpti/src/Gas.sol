// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

// TO BE OPTIMISED
// Optimize storage slots
// Transform modifier functions into internal functions.
// Optimize the size of variables (for example timestamps do not need to be uint256).
// Variables that are only set once can be set as immutable if they are initialized in the constructor
// Variables that do not change in value can be set as constant
// Delete / reset varaibles after use

contract GasContract {
    uint256 immutable totalSupply;
    uint8 paymentCounter = 0;
    mapping(address => uint256) public balances;
    // tradePercent is being used as a constant for setting the lenght of the status array in addHistory function which is not needed
    //uint8 constant tradePercent = 12;
    address immutable contractOwner;
    mapping(address => Payment[]) payments;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;
    enum PaymentType {
        Unknown,
        BasicPayment//,
        // Refund,
        // Dividend,
        // GroupPayment
    }
    // defaultPayment is not being used can be removed.
    //PaymentType constant defaultPayment = PaymentType.Unknown;

    History[] public paymentHistory; // when a payment was updated

    struct Payment {
        PaymentType paymentType;
        uint8 paymentID;
        bool adminUpdated;
        bytes8 recipientName; // max 8 characters
        address recipient;
        address admin; // administrators address
        uint256 amount;
    }

    struct History {
        uint32 lastUpdate;
        address updatedBy;
        uint32 blockNumber;
    }
    // uint8 wasLastOdd = 1;
    // mapping(address => uint8) public isOddWhitelistUser;

    struct ImportantStruct {
        uint256 amount;
        uint8 valueA; // max 3 digits
        uint8 bigValue;
        uint8 valueB; // max 3 digits
        bool paymentStatus;
        address sender;
    }
    mapping(address => ImportantStruct) public whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);

    modifier onlyAdminOrOwner() {
        address senderOfTx = msg.sender;
        if (!checkForAdmin(senderOfTx) && senderOfTx != contractOwner) {
            revert originatorNotSenderError();
        }
        _;
    }

    modifier checkIfWhiteListed(address sender) {
        address senderOfTx = msg.sender;
        if (senderOfTx != sender) {
            revert originatorNotSenderError();
        }
        uint256 usersTier = whitelist[senderOfTx];
        if (usersTier <= 0) {
            revert notWhitelistedError();
        }
        if (usersTier >= 4) {
            revert incorrectTierError();
        }
        _;
    }

    event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(
        address admin,
        uint256 ID,
        uint256 amount,
        bytes8 recipient
    );
    event WhiteListTransfer(address indexed);

    error originatorNotSenderError();
    error notWhitelistedError();
    error incorrectTierError();
    error nonZeroAddressError();
    error insufficientBalanceError();
    error nameTooLongError();
    error idNotGreaterThanZeroError();
    error amountNotGreaterThanZeroError();
    error tierGreaterThan255Error();
    error amountSmallerThanThreeError();
    // error hacked();

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        totalSupply = _totalSupply;

        // 1) loop through administrators array with 5 empty slots
        // 2) skip loops where the address in _admins array is 0
        // 3) add element from _admins array (input) to administrators array (storage)
        // 4) set the balance of the address in the administrators array to 0, except for the contractOwner
        balances[msg.sender] = _totalSupply;
        emit supplyChanged(msg.sender, _totalSupply);
        unchecked{
        for (uint256 ii = 0; ii < administrators.length; ii++) {
            if (_admins[ii] != address(0)) {
                administrators[ii] = _admins[ii];
                if (_admins[ii] != msg.sender) {
                    balances[_admins[ii]] = 0;
                    emit supplyChanged(_admins[ii], 0);
                }
            }
        }
        }
    }

    // REMOVED getPaymentHistory() FUNCTION

    function checkForAdmin(address _user) public view returns (bool admin_) {
        bool admin = false;
        unchecked{
        for (uint256 ii = 0; ii < administrators.length; ii++) {
            if (administrators[ii] == _user) {
                 admin = true;
            }
        }
        }
        return admin;
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        uint256 balance = balances[_user];
        return balance;
    }

    function addHistory(
        address _updateAddress,
        bool _tradeMode
    ) public returns (bool status_, bool tradeMode_) {
        History memory history;
        history.blockNumber = uint32(block.number);
        history.lastUpdate = uint32(block.timestamp);
        history.updatedBy = _updateAddress;
        paymentHistory.push(history);
        //Following block is not needed as the status is not used
        // bool[] memory status = new bool[](tradePercent);
        // unchecked{
        // for (uint8 i = 0; i < tradePercent; i++) {
        //     status[i] = true;
        // }
        // }
        // As status is always true following return statement can be replaced with return (true, _tradeMode);
        //return ((status[0] == true), _tradeMode);
        return (true, _tradeMode);
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public returns (bool status_) {
        address senderOfTx = msg.sender;
        if (balances[senderOfTx] < _amount) {
            revert insufficientBalanceError();
        }
        if (bytes(_name).length >= 9) {
            revert nameTooLongError();
        }
        unchecked{
        balances[senderOfTx] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        Payment memory payment;
        payment.admin = address(0);
        payment.adminUpdated = false;
        payment.paymentType = PaymentType.BasicPayment;
        payment.recipient = _recipient;
        payment.amount = _amount;
        // this code takes _name from calldata and then converts to bytes8, the recipientName has only up to 8 characters.
        // Maybe there is a more efficient way to do that in assembly.
        bytes memory nameBytes = bytes(_name);
        bytes8 nameBytes8;
        for(uint i = 0; i < nameBytes.length; i++) {
            nameBytes8 |= bytes8(nameBytes[i]) >> (i * 8);
        }
        payment.recipientName = nameBytes8;        
        payment.paymentID = ++paymentCounter;
        payments[senderOfTx].push(payment);
        //Following block is not needed as the status is not used
        // bool[] memory status = new bool[](tradePercent);

        // for (uint256 i = 0; i < tradePercent; i++) {
        //     status[i] = true;
        // }
        //This return statement can be replaced by a simple return true
        // return (status[0] == true);
        return true;
        }
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) public onlyAdminOrOwner {
        if (_ID <= 0) {
            revert idNotGreaterThanZeroError();
        }
        if (_amount <= 0) {
            revert amountNotGreaterThanZeroError();
        }
        if (_user == address(0)) {
            revert nonZeroAddressError();
        }

        address senderOfTx = msg.sender;
        unchecked{
        for (uint256 ii = 0; ii < payments[_user].length; ii++) {
            if (payments[_user][ii].paymentID == _ID) {
                payments[_user][ii].adminUpdated = true;
                payments[_user][ii].admin = _user;
                payments[_user][ii].paymentType = _type;
                payments[_user][ii].amount = _amount;
                bool tradingMode = true;
                addHistory(_user, tradingMode);
                emit PaymentUpdated(
                    senderOfTx,
                    _ID,
                    _amount,
                    payments[_user][ii].recipientName
                );
            }
        }
        }
    }

    function addToWhitelist(
        address _userAddrs,
        uint256 _tier
    ) public onlyAdminOrOwner {
        if (_tier >= 255) {
            revert tierGreaterThan255Error();
        }
        whitelist[_userAddrs] = _tier;
        unchecked{
        if (_tier > 3) {
            whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 3;
        } else if (_tier == 1) {
            whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 1;
        } else if (_tier > 0 && _tier < 3) {
            whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 2;
        }
        }
        // uint8 wasLastAddedOdd = wasLastOdd;
        // if (wasLastAddedOdd == 1) {
        //     wasLastOdd = 0;
        //     isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;
        // } else if (wasLastAddedOdd == 0) {
        //     wasLastOdd = 1;
        //     isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;
        // } else {
        //     revert hacked();
        // }
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount
    ) public checkIfWhiteListed(msg.sender) {
        address senderOfTx = msg.sender;
        whiteListStruct[senderOfTx] = ImportantStruct(
            _amount,
            0,
            0,
            0,
            true,
            msg.sender
        );
        if (balances[senderOfTx] < _amount) {
            revert insufficientBalanceError();
        }
        if (_amount <= 3) {
            revert amountSmallerThanThreeError();
        }
        unchecked{
        balances[senderOfTx] -= _amount;
        balances[_recipient] += _amount;
        balances[senderOfTx] += whitelist[senderOfTx];
        balances[_recipient] -= whitelist[senderOfTx];
        }
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(
        address sender
    ) public view returns (bool, uint256) {
        return (
            whiteListStruct[sender].paymentStatus,
            whiteListStruct[sender].amount
        );
    }

    receive() external payable {
        payable(msg.sender).transfer(msg.value);
    }

    fallback() external payable {
        payable(msg.sender).transfer(msg.value);
    }
}
