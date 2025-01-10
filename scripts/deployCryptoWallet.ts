import {contractAddress, toNano} from '@ton/core';
import {Balances, CryptoWallet} from '../wrappers/CryptoWallet';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const randomInt = BigInt(Math.floor(Math.random() * 1000000));
    const cryptoWallet = provider.open(await CryptoWallet.fromInit(randomInt));





    await cryptoWallet.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(cryptoWallet.address);

    console.log("id", cryptoWallet.getUsdtBalance)

    // run methods on `cryptoWallet`
}
