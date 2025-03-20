import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import {Address, Builder, Cell, contractAddress, toNano} from '@ton/core';
import {CryptoWallet} from '../wrappers/CryptoWallet';
import '@ton/test-utils';





describe('CryptoWallet', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let cryptoWallet: SandboxContract<CryptoWallet>;



    beforeEach(async () => {
        blockchain = await Blockchain.create();

        const jettonMasterAddress = Address.parse('EQBxKeIJenM5hTzThZ4US5DQvKWNygIkS1UlEMqWBlFoaCnR');  // Replace with actual jetton master address
        const jettonWalletCode = Cell.fromBoc('BOC_CODE_HERE')[0];  // Replace with the actual BOC code of the Jetton wallet

        const initState = await CryptoWallet.fromInit(jettonWalletCode, jettonMasterAddress);

        cryptoWallet = blockchain.openContract(initState);


        deployer = await blockchain.treasury('deployer');

        const deployResult = await cryptoWallet.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: cryptoWallet.address,
            deploy: true,
            success: true,
        });
    });


    it('should deploy', async () => {

        const sendCrypto = await cryptoWallet.send(
            deployer.getSender(),
            {
                value: BigInt(1000000000), // 1 TON in nanoTON
            },
            {
                $$type: 'JattonTransferNotification',
                queryId: BigInt(42),
                amount: BigInt(5000000000),
                sender: deployer.address,
                forwardPayload: new Builder().endCell().beginParse(), // Empty payload
            }
        )

    });

    it('', async () => {

    });





});
