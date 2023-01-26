// SPDX-License-Identifier: MIT

// $$\      $$\                                               $$\      $$\                                 $$\                         
// $$$\    $$$ |                                              $$$\    $$$ |                                $$ |                        
// $$$$\  $$$$ | $$$$$$\  $$$$$$$\   $$$$$$\  $$\   $$\       $$$$\  $$$$ | $$$$$$\  $$$$$$$\   $$$$$$$\ $$$$$$\    $$$$$$\   $$$$$$\  
// $$\$$\$$ $$ |$$  __$$\ $$  __$$\ $$  __$$\ $$ |  $$ |      $$\$$\$$ $$ |$$  __$$\ $$  __$$\ $$  _____|\_$$  _|  $$  __$$\ $$  __$$\ 
// $$ \$$$  $$ |$$ /  $$ |$$ |  $$ |$$$$$$$$ |$$ |  $$ |      $$ \$$$  $$ |$$ /  $$ |$$ |  $$ |\$$$$$$\    $$ |    $$$$$$$$ |$$ |  \__|
// $$ |\$  /$$ |$$ |  $$ |$$ |  $$ |$$   ____|$$ |  $$ |      $$ |\$  /$$ |$$ |  $$ |$$ |  $$ | \____$$\   $$ |$$\ $$   ____|$$ |      
// $$ | \_/ $$ |\$$$$$$  |$$ |  $$ |\$$$$$$$\ \$$$$$$$ |      $$ | \_/ $$ |\$$$$$$  |$$ |  $$ |$$$$$$$  |  \$$$$  |\$$$$$$$\ $$ |      
// \__|     \__| \______/ \__|  \__| \_______| \____$$ |      \__|     \__| \______/ \__|  \__|\_______/    \____/  \_______|\__|      
//                                            $$\   $$ |                                                                               
//                                            \$$$$$$  |                                                                               
//                                             \______/                                                                                
// dev: @bcrypt2

pragma solidity 0.8.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size; assembly {
            size := extcodesize(account)
        } return size > 0;
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(address target,bytes memory data,string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(address target,bytes memory data,uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(address target,bytes memory data,uint256 value,string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    function functionStaticCall(address target,bytes memory data,string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }
    function functionDelegateCall(address target,bytes memory data,string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function verifyCallResult(bool success,bytes memory returndata,string memory errorMessage) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
library SafeERC20 {
    using Address for address;
    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }
    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function safeIncreaseAllowance(IERC20 token,address spender,uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function safeDecreaseAllowance(IERC20 token,address spender,uint256 value) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }
    function _callOptionalReturn(IERC20 token, bytes memory data) private {   
        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
    }
}

struct User {
    uint256 startDate;
    uint256 divs;
    uint256 refBonus;
    uint256 totalInits;
    uint256 totalWiths;
    uint256 totalAccrued;
    uint256 lastWith;
    uint256 timesCmpd;
    uint256 keyCounter;
    Depo [] depoList;
}
struct Depo {
    uint256 key;
    uint256 depoTime;
    uint256 amt;
    address reffy;
    bool initialWithdrawn;
}
struct Main {
    uint256 ovrTotalDeps;
    uint256 ovrTotalWiths;
    uint256 users;
    uint256 compounds;
}
struct DivPercs{
    uint256 daysInSeconds;
    uint256 divsPercentage;
}
struct FeesPercs{
    uint256 daysInSeconds;
    uint256 feePercentage;
}
contract MoneyMonster_Staking {
    using SafeMath for uint256;
    uint256 constant launch = 1674437281;
  	uint256 constant hardDays = 86400;
    uint256 constant minStakeAmt = 50 * 10**18;
    uint256 constant percentdiv = 1000;
    uint256 refPercentage = 100;
    uint256 devPercentage = 100;
    mapping (address => mapping(uint256 => Depo)) public DeposMap;
    mapping (address => User) public UsersKey;
    mapping (uint256 => DivPercs) public PercsKey;
    mapping (uint256 => FeesPercs) public FeesKey;
    mapping (uint256 => Main) public MainKey;
    using SafeERC20 for IERC20;
    IERC20 public BUSD;
    address public owner;
    address public dev;

    constructor() {
            owner = address(0xA343c440ff331870554A5C9544756C21D9cCA4C0);
            dev = address(0x60F611Aec0bD6E2f8D0C5709742DA647dF9526A2);
            PercsKey[5] = DivPercs(432000, 35);
            PercsKey[10] = DivPercs(864000, 40);
            PercsKey[15] = DivPercs(1296000, 45);
            PercsKey[20] = DivPercs(1728000, 60);
            PercsKey[25] = DivPercs(2160000, 65);
            FeesKey[5] = FeesPercs(432000, 200);
            FeesKey[10] = FeesPercs(864000, 190);
            FeesKey[15] = FeesPercs(1296000, 180);
            FeesKey[20] = FeesPercs(1728000, 20);
            FeesKey[25] = FeesPercs(2160000, 10);

            BUSD = IERC20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56); 
            // BUSD = IERC20(0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7); 
    }

    function fundContract(uint256 _amount) external {
        BUSD.safeTransferFrom(msg.sender, address(this), _amount);
    }

    function stakeStablecoins(uint256 amtx, address ref) external {
        require(block.timestamp >= launch, "App did not launch yet.");
        require(ref != msg.sender, "You cannot refer yourself!");
        require(amtx >= minStakeAmt, "You should stake at least 50.");
        BUSD.safeTransferFrom(msg.sender, address(this), amtx);
        User storage user = UsersKey[msg.sender];
        User storage user2 = UsersKey[ref];
        Main storage main = MainKey[1];
        if (user.lastWith == 0){
            user.lastWith = block.timestamp;
            user.startDate = block.timestamp;
        }
        uint256 userStakePercentAdjustment = 1000 - devPercentage;
        uint256 adjustedAmt = amtx.mul(userStakePercentAdjustment).div(percentdiv); 
        uint256 stakeFee = amtx.mul(devPercentage).div(percentdiv); 
        
        user.totalInits += adjustedAmt; 
        uint256 refAmtx = adjustedAmt.mul(refPercentage).div(percentdiv);
        if (ref != 0x000000000000000000000000000000000000dEaD) {
            user2.refBonus += refAmtx;
        }

        user.depoList.push(Depo({
            key: user.depoList.length,
            depoTime: block.timestamp,
            amt: adjustedAmt,
            reffy: ref,
            initialWithdrawn: false
        }));

        user.keyCounter += 1;
        main.ovrTotalDeps += 1;
        main.users += 1;
        
        BUSD.safeTransfer(owner, stakeFee * 8/10);
        BUSD.safeTransfer(dev, stakeFee * 2/10);
    }

    function userInfo() view external returns (Depo [] memory depoList) {
        User storage user = UsersKey[msg.sender];
        return(
            user.depoList
        );
    }

    function withdrawDivs() external returns (uint256 withdrawAmount) {
        User storage user = UsersKey[msg.sender];
        Main storage main = MainKey[1];
        uint256 x = calcdiv(msg.sender);
      
      	for (uint i = 0; i < user.depoList.length; i++){
          if (user.depoList[i].initialWithdrawn == false) {
            user.depoList[i].depoTime = block.timestamp;
          }
        }

        uint256 adjustedPercent = 1000 - devPercentage;
        uint256 adjustedAmt = x.mul(adjustedPercent).div(percentdiv); 
        uint256 withdrawFee = x.mul(devPercentage).div(percentdiv);

        main.ovrTotalWiths += x;
        user.lastWith = block.timestamp;

        BUSD.safeTransfer(owner, withdrawFee * 8/10);
        BUSD.safeTransfer(dev, withdrawFee * 2/10);
        BUSD.safeTransfer(msg.sender, adjustedAmt);

        return x;
    }

    function withdrawInitial(uint256 keyy) external {
      	  
      	User storage user = UsersKey[msg.sender];
				
      	require(user.depoList[keyy].initialWithdrawn == false, "This has already been withdrawn.");
      
        uint256 initialAmt = user.depoList[keyy].amt; 
        uint256 currDays1 = user.depoList[keyy].depoTime;
        uint256 currTime = block.timestamp;
        uint256 currDays = currTime - currDays1;
        uint256 transferAmt;
      	
        if (currDays < FeesKey[5].daysInSeconds){ // LESS THAN 5 DAYS STAKED
            uint256 minusAmt = initialAmt.mul(FeesKey[5].feePercentage).div(percentdiv); //20% fee
           	
          	uint256 dailyReturn = initialAmt.mul(PercsKey[5].divsPercentage).div(percentdiv);
            uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
          	
          	transferAmt = initialAmt + currentReturn - minusAmt;
          
            user.depoList[keyy].amt = 0;
            user.depoList[keyy].initialWithdrawn = true;
            user.depoList[keyy].depoTime = block.timestamp;

            BUSD.safeTransfer(msg.sender, transferAmt);
        } else if (currDays >= FeesKey[5].daysInSeconds && currDays < FeesKey[10].daysInSeconds){ // BETWEEN 5 and 10 DAYS
            uint256 minusAmt = initialAmt.mul(FeesKey[10].feePercentage).div(percentdiv); //19% fee
						
          	uint256 dailyReturn = initialAmt.mul(PercsKey[10].divsPercentage).div(percentdiv);
            uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
						transferAmt = initialAmt + currentReturn - minusAmt;

            user.depoList[keyy].amt = 0;
            user.depoList[keyy].initialWithdrawn = true;
            user.depoList[keyy].depoTime = block.timestamp;

            BUSD.safeTransfer(msg.sender, transferAmt);
        } else if (currDays >= FeesKey[10].daysInSeconds && currDays < FeesKey[15].daysInSeconds){ // BETWEEN 10 and 15 DAYS
            uint256 minusAmt = initialAmt.mul(FeesKey[15].feePercentage).div(percentdiv); //18% fee
            
          	uint256 dailyReturn = initialAmt.mul(PercsKey[15].divsPercentage).div(percentdiv);
            uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
						transferAmt = initialAmt + currentReturn - minusAmt;

            user.depoList[keyy].amt = 0;
            user.depoList[keyy].initialWithdrawn = true;
            user.depoList[keyy].depoTime = block.timestamp;

            BUSD.safeTransfer(msg.sender, transferAmt);
        } else if (currDays >= FeesKey[15].daysInSeconds && currDays < FeesKey[20].daysInSeconds){ // BETWEEN 15 and 20 DAYS
            uint256 minusAmt = initialAmt.mul(FeesKey[20].feePercentage).div(percentdiv); //2% fee
            
          	uint256 dailyReturn = initialAmt.mul(PercsKey[20].divsPercentage).div(percentdiv);
            uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
						transferAmt = initialAmt + currentReturn - minusAmt;

            user.depoList[keyy].amt = 0;
            user.depoList[keyy].initialWithdrawn = true;
            user.depoList[keyy].depoTime = block.timestamp;

            BUSD.safeTransfer(msg.sender, transferAmt);
        } else if (currDays >= FeesKey[20].daysInSeconds && currDays < FeesKey[25].daysInSeconds){ // BETWEEN 20 and 25 DAYS
            uint256 minusAmt = initialAmt.mul(FeesKey[25].feePercentage).div(percentdiv); //1% fee
            
          	uint256 dailyReturn = initialAmt.mul(PercsKey[25].divsPercentage).div(percentdiv);
            uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
						transferAmt = initialAmt + currentReturn - minusAmt;

            user.depoList[keyy].amt = 0;
            user.depoList[keyy].initialWithdrawn = true;
            user.depoList[keyy].depoTime = block.timestamp;

            BUSD.safeTransfer(msg.sender, transferAmt);
        } else if (currDays >= FeesKey[25].daysInSeconds){ // 25+ DAYS
            uint256 minusAmt = initialAmt.mul(FeesKey[25].feePercentage).div(percentdiv); //1% fee
            
          	uint256 dailyReturn = initialAmt.mul(PercsKey[25].divsPercentage).div(percentdiv);
            uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
						transferAmt = initialAmt + currentReturn - minusAmt;

            user.depoList[keyy].amt = 0;
            user.depoList[keyy].initialWithdrawn = true;
            user.depoList[keyy].depoTime = block.timestamp;
            
            BUSD.safeTransfer(msg.sender, transferAmt);
        } else {
            revert("Could not calculate the # of days you've been staked.");
        }
    }

    function withdrawRefBonus() external {
        User storage user = UsersKey[msg.sender];
        uint256 amtz = user.refBonus;
        user.refBonus = 0;

        BUSD.safeTransfer(msg.sender, amtz);
    }

    function stakeRefBonus() external { 
        User storage user = UsersKey[msg.sender];
        Main storage main = MainKey[1];
        require(user.refBonus > 10);
      	uint256 refferalAmount = user.refBonus;
        user.refBonus = 0;
        address ref = 0x000000000000000000000000000000000000dEaD; //DEAD ADDRESS
				
        user.depoList.push(Depo({
            key: user.keyCounter,
            depoTime: block.timestamp,
            amt: refferalAmount,
            reffy: ref, 
            initialWithdrawn: false
        }));

        user.keyCounter += 1;
        main.ovrTotalDeps += 1;
    }

    function calcdiv(address dy) public view returns (uint256 totalWithdrawable) {
        User storage user = UsersKey[dy];	

        uint256 with;
        
        for (uint256 i = 0; i < user.depoList.length; i++){	
            uint256 elapsedTime = block.timestamp.sub(user.depoList[i].depoTime);

            uint256 amount = user.depoList[i].amt;
            if (user.depoList[i].initialWithdrawn == false) {
                if (elapsedTime <= PercsKey[5].daysInSeconds) { 
                    uint256 dailyReturn = amount.mul(PercsKey[5].divsPercentage).div(percentdiv);
                    uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[5].daysInSeconds / 5);
                    with += currentReturn;
                }
                if (elapsedTime > PercsKey[5].daysInSeconds && elapsedTime <= PercsKey[10].daysInSeconds) {
                    uint256 dailyReturn = amount.mul(PercsKey[10].divsPercentage).div(percentdiv);
                    uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[10].daysInSeconds / 10);
                    with += currentReturn;
                }
                if (elapsedTime > PercsKey[10].daysInSeconds && elapsedTime <= PercsKey[15].daysInSeconds) {
                    uint256 dailyReturn = amount.mul(PercsKey[15].divsPercentage).div(percentdiv);
                    uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[15].daysInSeconds / 15);
                    with += currentReturn;
                }
                if (elapsedTime > PercsKey[15].daysInSeconds && elapsedTime <= PercsKey[20].daysInSeconds) {
                    uint256 dailyReturn = amount.mul(PercsKey[20].divsPercentage).div(percentdiv);
                    uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[20].daysInSeconds / 20);
                    with += currentReturn;
                }
                if (elapsedTime > PercsKey[20].daysInSeconds && elapsedTime <= PercsKey[25].daysInSeconds) {
                    uint256 dailyReturn = amount.mul(PercsKey[25].divsPercentage).div(percentdiv);
                    uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[25].daysInSeconds / 25);
                    with += currentReturn;
                }
                if (elapsedTime > PercsKey[25].daysInSeconds) {
                    uint256 dailyReturn = amount.mul(PercsKey[25].divsPercentage).div(percentdiv);
                    uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[25].daysInSeconds / 25);
                    with += currentReturn;
                }
            }
        }
        return with;
    }

    function compound() external {
        User storage user = UsersKey[msg.sender];
        Main storage main = MainKey[1];

        uint256 y = calcdiv(msg.sender);

        for (uint i = 0; i < user.depoList.length; i++){
          if (user.depoList[i].initialWithdrawn == false) {
            user.depoList[i].depoTime = block.timestamp;
          }
        }

        user.depoList.push(Depo({
              key: user.keyCounter,
              depoTime: block.timestamp,
              amt: y,
              reffy: 0x000000000000000000000000000000000000dEaD, 
              initialWithdrawn: false
          }));

        user.keyCounter += 1;
        main.ovrTotalDeps += 1;
        main.compounds += 1;
        user.lastWith = block.timestamp;  
    }

    function changeOwner(address _account) external {
        require(msg.sender == owner, "Only owner is accessable");
        owner = _account;
    }

    function changeDev(address _account) external {
        require(msg.sender == dev, "Only dev is accessable");
        dev = _account;
    }
}