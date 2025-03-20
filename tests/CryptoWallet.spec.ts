import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import {address, Address, Builder, Cell, contractAddress, toNano} from '@ton/core';
import {CryptoWallet} from '../wrappers/CryptoWallet';
import '@ton/test-utils';
import {contentToCell} from "../wrappers/CryptoWallet.compile";


describe('CryptoWallet', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let cryptoWallet: SandboxContract<CryptoWallet>;



    beforeEach(async () => {
        blockchain = await Blockchain.create();

        const jettonMasterAddress = Address.parse('EQBxKeIJenM5hTzThZ4US5DQvKWNygIkS1UlEMqWBlFoaCnR');  // Replace with actual jetton master address
        const userWallet:Address = address("0QC1GuMlMyN4bLe0xRAUulsvTgL1Z03nnTo34C4gdUpsrxfg");


        const metaData = contentToCell({name: 'Havilla', symbol: "HVlA", maxsupply: BigInt(21000000)});

       let contract = blockchain.openContract(await CryptoWallet.fromInit(metaData, jettonMasterAddress));

        deployer = await blockchain.treasury('deployer');

        const deployResult = await contract.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

    });


    it('should deploy', async () => {



    });

    it('', async () => {

    });





});
