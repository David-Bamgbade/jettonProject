import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import {Builder, contractAddress, toNano} from '@ton/core';
import {Balances, CryptoWallet} from '../wrappers/CryptoWallet';
import '@ton/test-utils';



describe('CryptoWallet', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let cryptoWallet: SandboxContract<CryptoWallet>;


    beforeEach(async () => {
        blockchain = await Blockchain.create();

        const initState = await CryptoWallet.fromInit({
            $$type: "Balances",
            profitPerDay: BigInt(0),
            usdtBalance: BigInt(1000),
            tonBalance: BigInt(1000),
            dailyProfitRate: BigInt(1)
        });

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
        const initState = await CryptoWallet.fromInit({
            $$type: "Balances",
            profitPerDay: BigInt(0),
            usdtBalance: BigInt(0),
            tonBalance: BigInt(1000),
            dailyProfitRate: BigInt(1)
        });
    });

    it('should Get Ton Balance', async () => {
        const expectedTonBalance = BigInt(0);
        const tonBalance = await cryptoWallet.getTonBalance();
        expect(tonBalance).toEqual(expectedTonBalance);
        console.log(expectedTonBalance)
        console.log(tonBalance)
    });





});
