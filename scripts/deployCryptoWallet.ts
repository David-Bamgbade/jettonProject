import {address, Address, Cell, contractAddress, toNano} from '@ton/core';
import {CryptoWallet} from '../wrappers/CryptoWallet';
import { NetworkProvider } from '@ton/blueprint';
import {contentToCell} from "../wrappers/CryptoWallet.compile";

export async function run(provider: NetworkProvider) {

    const jettonMasterAddress = Address.parse('EQBxKeIJenM5hTzThZ4US5DQvKWNygIkS1UlEMqWBlFoaCnR');  // Replace with actual jetton master address
    const userWallet:Address = address("0QC1GuMlMyN4bLe0xRAUulsvTgL1Z03nnTo34C4gdUpsrxfg");


    const metaData = contentToCell({name: 'Havilla', symbol: "HVlA", maxsupply: BigInt(21000000)});
    const tonJetton = provider.open(await CryptoWallet.fromInit(metaData, jettonMasterAddress));


    await tonJetton.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(tonJetton.address);


    // run methods on `cryptoWallet`
}
