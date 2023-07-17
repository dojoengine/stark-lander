import { Account, RpcProvider, num, InvokeFunctionResponse, Provider, Contract } from 'starknet';

import abi from './abi.json';

export const KATANA_ACCOUNT_1_ADDRESS = "0x03ee9e18edc71a6df30ac3aca2e0b02a198fbce19b7480a63a0d71cbd76652e0"
export const KATANA_ACCOUNT_1_PRIVATEKEY = "0x0300001800000000300000180000000000030000000000003006001800006600"
export const WORLD_ADDRESS = "0x26065106fa319c3981618e7567480a50132f23932226a51c219ffb8e47daa84"
export const EVENT_KEY = "0x1a2f334228cee715f1f0f54053bb6b5eac54fa336e0bc1aacf7516decb0471d"

export const KATANA_RPC = "http://localhost:5050"

export type SetupNetworkResult = Awaited<ReturnType<typeof setupNetwork>>;

export function setupNetwork() {

    const provider = new RpcProvider({
        nodeUrl: KATANA_RPC,
    });

    const signer = new Account(provider, KATANA_ACCOUNT_1_ADDRESS, KATANA_ACCOUNT_1_PRIVATEKEY)

    return {
        provider,
        signer,
        execute: async (system: string, call_data: num.BigNumberish[]) => execute(signer, system, call_data),
        call: async (call_data: num.BigNumberish[]) => call(provider, call_data)
    };
}

export async function execute(account: Account, system: string, call_data: num.BigNumberish[]): Promise<InvokeFunctionResponse> {

    const nonce = await account?.getNonce()
    const call = await account?.execute(
        {
            contractAddress: WORLD_ADDRESS,
            entrypoint: 'execute',
            calldata: [strTofelt252Felt(system), call_data.length, ...call_data]
        },
        undefined,
        {
            nonce: nonce,
            maxFee: 0
        }
    );
    console.log("call", call)
    return call;
}

export async function call(provider: RpcProvider, call_data: num.BigNumberish[]) {
    // const { abi: testAbi } = await provider.getClassAt(WORLD_ADDRESS);

    // console.log(testAbi)
    const contract = new Contract(abi, WORLD_ADDRESS, provider);

    console.log(contract)

    const game = await contract.call('execute', call_data);

    console.log("game", game)
}

export function strTofelt252Felt(str: string): string {
    const encoder = new TextEncoder();
    const strB = encoder.encode(str);
    return BigInt(
        strB.reduce((memo, byte) => {
            memo += byte.toString(16)
            return memo
        }, '0x'),
    ).toString()
}

