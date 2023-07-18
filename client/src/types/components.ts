import math from "../utils/math";

export type Lander = {
	last_update: string;
	position_x: number;
	position_y: number;
	velocity_x: number;
	velocity_y: number;
	angle: number;
	fuel: number;
};

export function parseRawCalldataAsLander(calldata: string[]): Lander {
	return {
		last_update: BigInt(calldata[0]).toString(),
		position_x: parseMagAndSign(calldata[1], calldata[2]),
		position_y: parseMagAndSign(calldata[3], calldata[4]),
		velocity_x: parseMagAndSign(calldata[5], calldata[6]),
		velocity_y: parseMagAndSign(calldata[7], calldata[8]),
		angle: parseMagAndSign(calldata[9], calldata[10]),
		fuel: parseMagAndSign(calldata[11], calldata[12]),
	};
}

function parseMagAndSign(magValue: string, signValue: string) {
	const sign = BigInt(signValue) === BigInt(0) ? "" : "-";
	return math.fromFixed(`${sign}${magValue}`);
}
