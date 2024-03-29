// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

// TO BE OPTIMISED
// Optimize storage slots
// Variables that are only set once can be set as immutable if they are initialized in the constructor
// Variables that do not change in value can be set as constant
// Delete / reset varaibles after use

contract GasContract {
    address immutable contractOwner;

    address[5] public administrators;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public whitelist;
    // mapping(address => uint256) private whiteList;

    // uint256 immutable totalSupply;
    // mapping(address => Payment[]) payments;

    // enum PaymentType {
    //     Unknown,
    //     BasicPayment //,
    //     // Refund,
    //     // Dividend,
    //     // GroupPayment
    // }
    // defaultPayment is not being used can be removed.
    //PaymentType constant defaultPayment = PaymentType.Unknown;

    // History[] paymentHistory; // when a payment was updated

    // struct Payment {
    //     PaymentType paymentType;
    //     uint8 paymentID;
    //     bool adminUpdated;
    //     bytes8 recipientName; // max 8 characters
    //     address recipient;
    //     address admin; // administrators address
    //     uint256 amount;
    // }

    // struct History {
    //     uint32 lastUpdate;
    //     address updatedBy;
    //     uint32 blockNumber;
    // }
    // uint8 wasLastOdd = 1;
    // mapping(address => uint8) public isOddWhitelistUser;

    // struct ImportantStruct {
    //     uint256 amount;
    //     // uint8 valueA; // max 3 digits
    //     // uint8 bigValue;
    //     // uint8 valueB; // max 3 digits
    //     bool paymentStatus;
    //     // address sender;
    // }
    // mapping(address => ImportantStruct) whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);

    modifier onlyAdminOrOwner() {
        address senderOfTx = msg.sender;
        if (senderOfTx != contractOwner && !checkForAdmin(senderOfTx)) {
            revert originatorNotSenderError();
        }
        _;
    }

    modifier checkIfWhiteListed(address sender) {
        address senderOfTx = msg.sender;
        if (senderOfTx != sender) {
            revert originatorNotSenderError();
        }
        if (whitelist[senderOfTx] <= 0) {
            revert notWhitelistedError();
        }
        // if (usersTier >= 4) {
        //     revert incorrectTierError();
        // }
        _;
    }

    // event supplyChanged(address indexed, uint256 indexed);
    // event Transfer(address recipient, uint256 amount);
    // event PaymentUpdated(
    //     address admin,
    //     uint8 ID,
    //     uint256 amount,
    //     bytes8 recipient
    // );
    event WhiteListTransfer(address indexed);

    error originatorNotSenderError();
    error notWhitelistedError();
    // error incorrectTierError();
    // error nonZeroAddressError();
    // error insufficientBalanceError();
    // error nameTooLongError();
    // error idNotGreaterThanZeroError();
    // error amountNotGreaterThanZeroError();
    error tierGreaterThan255Error();

    // error amountSmallerThanThreeError();
    // error hacked();

    constructor(address[] memory _admins, uint256 _totalSupply) payable {
        contractOwner = msg.sender;
        // totalSupply = _totalSupply;

        // 1) loop through administrators array with 5 empty slots
        // 2) skip loops where the address in _admins array is 0
        // 3) add element from _admins array (input) to administrators array (storage)
        // 4) set the balance of the address in the administrators array to 0, except for the contractOwner
        balances[msg.sender] = _totalSupply;
        // emit supplyChanged(msg.sender, _totalSupply);
        unchecked {
            for (uint256 ii; ii < 5; ++ii) {
                if (_admins[ii] != address(0)) {
                    administrators[ii] = _admins[ii];
                    if (_admins[ii] != msg.sender) {
                        balances[_admins[ii]] = 0;
                        // emit supplyChanged(_admins[ii], 0);
                    }
                }
            }
        }

        // assembly {
        //     let sum := 0
        //     for { let n := 0 } lt(n, 100) { n := add(n, 1) } { sum := add(sum, n) }
        //     mstore(0, sum)
        //     return(0, 32)

        //     for { let i := 0 } lt(i, 5) { i := add(i, 1) } { sum := add(sum, i) }
        // }
    }

    // REMOVED getPaymentHistory() FUNCTION

    function checkForAdmin(address _user) public view returns (bool admin_) {
        // bool admin = false
        unchecked {
            for (uint256 ii; ii < administrators.length; ++ii) {
                if (administrators[ii] == _user) {
                    admin_ = true;
                    // return(true);
                    // break;
                }
            }
        }

        // assembly {
        //     let slot := keccak256(1, 32)
        //     for { let i := 0 } lt(i, 5) { i := add(i, 1) } {
        //         // Calculate the storage slot for the ith element
        //         let elementSlot := keccak256(add(slot, i), 32)

        //         // Load the address stored at this slot
        //         let element := sload(elementSlot)

        //         if eq(element, _user) {
        //             admin_ := 1
        //             break
        //         }
        //     }
        // }

        // return false;
    }

    function balanceOf(address _user) public view returns (uint256) {
        // uint256 balance = balances[_user];
        // return balance;
        return balances[_user];
    }

    // function addHistory(
    //     address _updateAddress,
    //     bool _tradeMode
    // ) private returns (bool status_, bool tradeMode_) {
    //     History memory history;
    //     history.blockNumber = uint32(block.number);
    //     history.lastUpdate = uint32(block.timestamp);
    //     history.updatedBy = _updateAddress;
    //     paymentHistory.push(history);
    //     bool[] memory status = new bool[](tradePercent);
    //     unchecked{
    //     for (uint8 i = 0; i < tradePercent; ++i) {
    //         status[i] = true;
    //     }
    //     }
    //     return ((status[0] == true), _tradeMode);
    // }

    function transfer(address _recipient, uint256 _amount, string calldata _name) external {
        address senderOfTx = msg.sender;
        // if (balances[senderOfTx] < _amount) {
        //     revert insufficientBalanceError();
        // }
        // if (bytes(_name).length >= 9) {
        //     revert nameTooLongError();
        // }
        unchecked {
            balances[senderOfTx] -= _amount;
            balances[_recipient] += _amount;
            // emit Transfer(_recipient, _amount);
            // Payment memory payment;
            // payment.admin = address(0);
            // payment.adminUpdated = false;
            // payment.paymentType = PaymentType.BasicPayment;
            // payment.recipient = _recipient;
            // payment.amount = _amount;
            // this code takes _name from calldata and then converts to bytes8, the recipientName has only up to 8 characters.
            // Maybe there is a more efficient way to do that in assembly.
            // bytes memory nameBytes = bytes(_name);
            // bytes8 nameBytes8;
            // for (uint i = 0; i < nameBytes.length; ++i) {
            //     nameBytes8 |= bytes8(nameBytes[i]) >> (i * 8);
            // }
            // payment.recipientName = nameBytes8;
            // payment.paymentID = ++paymentCounter;
            // payments[senderOfTx].push(payment);
            // bool[] memory status = new bool[](tradePercent);

            // for (uint256 i = 0; i < tradePercent; ++i) {
            //     status[i] = true;
            // }
            // return (status[0] == true);
            // status_ = true;
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) external onlyAdminOrOwner {
        if (_tier >= 255) {
            revert tierGreaterThan255Error();
        } else if (_tier >= 3) {
            whitelist[_userAddrs] = 3;
        } else {
            whitelist[_userAddrs] = _tier;
        }
        // whitelist[_userAddrs] = _tier;
        // unchecked{
        // if (_tier > 3) {
        //     // whitelist[_userAddrs] -= _tier;
        //     whitelist[_userAddrs] = 3;
        // // } else if (_tier == 1) {
        //     // whitelist[_userAddrs] -= _tier;
        //     // whitelist[_userAddrs] = 1;
        // } else if (_tier > 0 && _tier < 3) {
        //     // whitelist[_userAddrs] -= _tier;
        //     whitelist[_userAddrs] = 2;
        // }
        // }

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

    function whiteTransfer(address _recipient, uint256 _amount) external checkIfWhiteListed(msg.sender) {
        whitelist[msg.sender] = _amount;
        // if (balances[senderOfTx] < _amount) {
        //     revert insufficientBalanceError();
        // }
        // if (_amount <= 3) {
        //     revert amountSmallerThanThreeError();
        // }
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address sender) external view returns (bool, uint256) {
        return (true, whitelist[sender]);
    }

    // receive() external payable {
    //     payable(msg.sender).transfer(msg.value);
    // }

    // fallback() external payable {
    //     payable(msg.sender).transfer(msg.value);
    // }
}
