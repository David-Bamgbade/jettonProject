import { CompilerConfig } from '@ton/blueprint';

export const compile: CompilerConfig = {
    lang: 'tact',
    target: 'contracts/crypto_wallet.tact',
    options: {
        debug: true,
    },
};
