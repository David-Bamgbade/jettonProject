import { CompilerConfig } from '@ton/blueprint';
import {Contract, ContractProvider, Address, Sender, toNano, beginCell, Cell} from '@ton/core';


export const compile: CompilerConfig = {
    lang: 'tact',
    target: 'contracts/crypto_wallet.tact',
    options: {
        debug: true,
    },
};

export function contentToCell(meta: { name: string; symbol: string; maxsupply: bigint }): Cell {
    return beginCell()
        .storeUint(0x01, 8) // Metadata version (optional; can be omitted if not needed)
        .storeStringTail(meta.name) // Store name as a string reference
        .storeStringTail(meta.symbol) // Store symbol as a string reference
        .storeUint(meta.maxsupply, 64) // Store max supply as a 64-bit unsigned integer
        .endCell();
}

export class CryptoWallet implements Contract {
    readonly address: Address;
    readonly init?: any; // Replace `any` with the actual `StateInit` type if applicable
    readonly abi?: any; // Replace `any` with the actual `ContractABI` type if applicable

    constructor(address: Address) {
        this.address = address;
    }

    // Function to mint tokens
    async mint(provider: ContractProvider, sender: Sender, to: Address, amount: number): Promise<void> {
        const body = this.buildMintBody(to, amount);

        await provider.internal(sender, {
            value: toNano('0.1'), // Transaction fee
            body,
        });
    }

    // Helper function to build the body of the mint transaction
    private buildMintBody(to: Address, amount: number) {
        return beginCell()
            .storeUint(0x1234abcd, 32) // Replace with your function selector
            .storeAddress(to)
            .storeUint(amount, 64)
            .endCell();
    }
}


