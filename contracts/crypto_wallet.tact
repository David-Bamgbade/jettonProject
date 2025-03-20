import "@stdlib/deploy";

fun calculateJettonWalletAddress(
ownerAddress: Address,
jettonMasterAddress: Address,
jettonWalletCode: Cell
): Address {
    let initData = JettonWalletData {
    balance: 0,
    ownerAddress,
    jettonMasterAddress,
    jettonWalletCode
    };
    return contractAddress (StateInit{
    code: jettonWalletCode,
    data: initData.toCell(),
    });
}

message(0x7362d09c) JattonReceiveNotification {
    queryId: Int;
    amount: Int;
    sender: Address;
    forwardPayload: Slice;
}

message(0xf8a7ea5) JettonTransfer {
    queryId: Int as uint64;
    amount: Int as coins;
    destination: Address;
    responseDestination: Address;
    customPayload: Cell? = null ;
    forwardTonAmount: Int;
    forwardPayload: Slice as remaining;
}

struct JettonWalletData {
    balance: Int;
    ownerAddress: Address;
    jettonMasterAddress: Address;
    jettonWalletCode: Cell;
}

const JettonTransferGasFee: Int = ton("0.05");

contract CryptoWallet with Deployable {
    myJettonWalletAddress: Address;
    myjettonTransferAmount: Int = 0;


    fun myAddress(): Address {
        return self.myJettonWalletAddress;
    }

    fun contractAddress(codeAndDataOfContract: StateInit): Address {
        return self.myJettonWalletAddress;
    }

    fun setTranferAmount(amount: Int) {
        self.myjettonTransferAmount = amount;
    }

    init(jettonWalletCode: Cell, jettonMasterAddress: Address) {
        self.myJettonWalletAddress = calculateJettonWalletAddress (
        myAddress(),
        jettonMasterAddress,
        jettonWalletCode,
        );
    }

    receive (msg: JattonReceiveNotification) {
        require (
        msg.sender == self.myJettonWalletAddress,
        "Not From Your Jetton Wallet"
        );
        self.myjettonTransferAmount += msg.amount;
        self.sendJetton(msg.sender, msg.amount);
    }

    fun sendJetton(recipient: Address, amount: Int) {
        let transferParams = JettonTransfer {
        queryId: 42,
        amount,
        destination: recipient,
        responseDestination: recipient,
        customPayload: null,
        forwardTonAmount: 0,
        forwardPayload: rawSlice("F")
        };
        send(SendParameters{
        to: self.myJettonWalletAddress,
        value: ton("0.05"),
        body: transferParams.toCell()
        });
    }





}











//    fun withdrawTon(amount: Int, reciepient: Address ) {
//        require (
//            amount > 0,
//            "Amount Must Be Greater Than 1"
//        );
//        require(
//            self.myTonBalance >= amount,
//            "Insufficient Ton Balance"
//        );
//        self.myTonBalance -= amount;
//        sendTon(reciepient, amount);
//    }
//
//    fun withdrawUsdt(amount: Int, reciepient: Address) {
//        require (
//            amount > 0,
//            "Amount Must Be Greater Than 0"
//        );
//        require (
//            self.myUsdtBalance > amount,
//            "Insufficient Usdt Balance"
//        );
//        self.myUsdtBalance -= amount;
//        sendUsdt (
//            self.myJettonWalletAddress,
//            TonTransferNotification{
//            queryId: 0,
//            amount,
//            sender: myAddress(),
//        },
//        usdtTransferGasFee
//        );
//   }

























//message Add {
//    queryId: Int;
//    amount: Int;
//}
//
//struct Balances {
//    usdtBalance: Int;
//    tonBalance: Int;
//    profitPerDay: Int;
//    dailyProfitRate: Int = 5 / 10;
//}
//
//contract CryptoWallet with Deployable {
//    balance : Balances;
//
//    init( balance : Balances) {
//        self.balance = Balances{
//        profitPerDay: 0,
//        usdtBalance: 0,
//        tonBalance: 0,
//        dailyProfitRate: 0
//        };
//    }
//
//    fun depositUsdt(usdtDeposit: Int): Balances {
//        self.balance.usdtBalance = self.balance.usdtBalance + usdtDeposit;
//        return self.balance
//    }
//
//    fun depositTon(tonDeposit: Int): Balances {
//      self.balance.tonBalance = self.balance.tonBalance + tonDeposit;
//        return self.balance
//    }
//
//    get fun tonBalance(): Int {
//        return self.balance.tonBalance
//    }
//
//    get fun usdtBalance(): Int {
//        return self.balance.usdtBalance;
//    }
//
//    fun withdrawUsdt(usdtAmount: Int) {
//        if (self.balance.usdtBalance > usdtAmount) {
//            self.balance.usdtBalance - usdtAmount;
//            dump(usdtAmount)
//        } else {
//            dump("Insuficient Balance")
//        }
//    }
//
//    fun withdrawTon(tonAmount: Int) {
//        if (self.balance.tonBalance > tonAmount) {
//            self.balance.tonBalance - tonAmount;
//            dump(tonAmount)
//        } else {
//            dump ("Insuficient Balnace")
//        }
//    }
//
//    fun dailyPnl() {
//        if (self.balance.tonBalance > 30) {
//            let rate = self.balance.dailyProfitRate / 100;
//            let pnl = self.balance.tonBalance * rate;
//            self.balance.profitPerDay = pnl;
//            dump(pnl)
//        }
//    }
//
//    get fun todaysPnl(): Int {
//        return self.balance.profitPerDay;
//    }

//}