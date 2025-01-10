import "@stdlib/deploy";

message(0x7362d09c) JettonTransferNotification {
    queryId: Int;
    amount: Int;
    sender: Address;
    forwardPayload: Slice;
}

message(0xf8a7ea5) JettonTransfer {
    queryId: Int;
    amount: Int;
    destination: Address;
    responseDestintion: Address;
    customPayload: Cell? = null;
    forwardTonAmount: Int;
    forwardPayload: Slice as remaining;
}

const usdtTransferGasFee: Int = ton ("0.05");

struct JettonWalletData {
    balance: Int;
    ownerAddress: Address;
    jettonMasterAddress: Address;
    jettonWalletCode: Cell;
}

struct UsdtWalletData {
    status: Int;
    balance: Int;
    ownerAddress: Address;
    jettonMasterAddress: Address;
}


message Withdraw {
    amount: Int;
}

contract CryptoWallet with Deployable {

    myTonBalance: Int = 0;
    myUsdtBalance: Int = 0;
    myJettonWalletAddress: Address;

    init(jettonWalletCode: Cell, jettonMasterAddress: Address) {
        self.myJettonWalletAddress = calculateJettonWalletAddress (
        myAddress(),
        jettonMasterAddress,
        jettonWalletCode
        );
    }



    fun contractAddress(codeAndDataOfContract: StateInit): Address {
        return self.myJettonWalletAddress;
    }
    fun myAddress(): Address {
        return self.myJettonWalletAddress;
    }
    fun sendTon(reciepient: Address, amount: Int): Int {
        return self.myTonBalance
    }
    fun sendUsdt(myJettonAddress: Address, transferNotification: JettonTransferNotification, tranferFee: Int, payLoad: Slice): Int {
        return self.myUsdtBalance;
    }

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

    fun calculateUsdtWalletAddress (
        ownerAddress: Address,
        jettonMasterAddress: Address,
        jettonWalletCode: Cell
    ): Address {
        let initData = UsdtWalletData {
            status: 0,
            balance: 0,
            ownerAddress,
            jettonMasterAddress,
        };
        return contractAddress(StateInit{
            code: jettonWalletCode,
            data: initData.toCell()
        });
    }


    receive(msg: JettonTransferNotification) {
        require (
            myAddress() == self.myJettonWalletAddress,
            "Transfer Is Not From Your Jetton Wallet"
        );
        self.myUsdtBalance += msg.amount;
    }

    fun withdrawTon(amount: Int, reciepient: Address ) {
        require (
            amount > 0,
            "Amount Must Be Greater Than 1"
        );
        require(
            self.myTonBalance >= amount,
            "Insufficient Ton Balance"
        );
        self.myTonBalance -= amount;
        sendTon(reciepient, amount);
    }

    fun withdrawUsdt(amount: Int, reciepient: Address) {
        require (
            amount > 0,
            "Amount Must Be Greater Than 0"
        );
        require (
            self.myUsdtBalance > amount,
            "Insufficient Usdt Balance"
        );
        self.myUsdtBalance -= amount;
        sendUsdt (
            self.myJettonWalletAddress,
            JettonTransferNotification{
            queryId: 0,
            amount,
            sender: myAddress(),
        },
        usdtTransferGasFee
        );
    }





}



















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