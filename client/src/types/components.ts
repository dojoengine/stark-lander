import math from "../utils/math";

export type Lander = {
	last_update: string;
	position_x: string;
	position_y: string;
	velocity_x: string;
	velocity_y: string;
	angle: string;
	fuel: number;
};

export function parseRawCalldataAsLander(calldata: string[]): Lander {

	console.log(calldata[11])
	return {
		last_update: BigInt(calldata[1]).toString(),
		position_x: parseMagAndSign(calldata[2], calldata[3]),
		position_y: parseMagAndSign(calldata[4], calldata[5]),
		velocity_x: parseMagAndSign(calldata[6], calldata[7]),
		velocity_y: parseMagAndSign(calldata[8], calldata[9]),
		angle: parseMagAndSign(calldata[10], calldata[11]),
		fuel: parseInt(calldata[12]) ,
	};
}

function parseMagAndSign(magValue: string, signValue: string) {
	const sign = BigInt(signValue) === BigInt(0) ? "" : "-";
	return math.fromFixed(`${sign}${magValue}`).toFixed(2);
}
``