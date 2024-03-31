import {
	Account,
	RpcProvider,
	num,
	InvokeFunctionResponse,
	Provider,
	Contract,
} from "starknet";

import abi from "./abi.json";

export const KATANA_ACCOUNT_1_ADDRESS =
	"0x03ee9e18edc71a6df30ac3aca2e0b02a198fbce19b7480a63a0d71cbd76652e0";
export const KATANA_ACCOUNT_1_PRIVATEKEY =
	"0x0300001800000000300000180000000000030000000000003006001800006600";
export const WORLD_ADDRESS =
	"0x37789dc51b4d31948b9994f92fdfd72c800002e1823d96e3d77df437659d08f";
export const EVENT_KEY =
	"0x1a2f334228cee715f1f0f54053bb6b5eac54fa336e0bc1aacf7516decb0471d";

export const KATANA_RPC = "http://localhost:5050";

export type SetupNetworkResult = Awaited<ReturnType<typeof setupNetwork>>;

export function setupNetwork() {
	const provider = new RpcProvider({
		nodeUrl: KATANA_RPC,
	});

	const signer = new Account(
		provider,
		KATANA_ACCOUNT_1_ADDRESS,
		KATANA_ACCOUNT_1_PRIVATEKEY
	);

	return {
		provider,
		signer,
		execute: async (system: string, call_data: num.BigNumberish[]) =>
			execute(signer, system, call_data),
		call_execute: async (call_data: any[]) => call_execute(provider, call_data),
		call: async (selector: string, call_data: any[]) =>
			call(provider, selector, call_data),
	};
}

async function execute(
	account: Account,
	system: string,
	call_data: num.BigNumberish[]
): Promise<InvokeFunctionResponse> {
	const nonce = await account?.getNonce();
	const call = await account?.execute(
		{
			contractAddress: WORLD_ADDRESS,
			entrypoint: "execute",
			calldata: [strTofelt252Felt(system), call_data.length, ...call_data],
		},
		undefined,
		{
			nonce: nonce,
			maxFee: 0,
		}
	);
	return call;
}

function call_execute(provider: RpcProvider, call_data: any[]) {
	return new Contract(abi, WORLD_ADDRESS, provider).call("execute", call_data);
}

function call(provider: RpcProvider, selector: string, call_data: any[]) {
	return new Contract(abi, WORLD_ADDRESS, provider).call(selector, call_data);
}

export function strTofelt252Felt(str: string): string {
	const encoder = new TextEncoder();
	const strB = encoder.encode(str);
	return BigInt(
		strB.reduce((memo, byte) => {
			memo += byte.toString(16);
			return memo;
		}, "0x")
	).toString();
}
