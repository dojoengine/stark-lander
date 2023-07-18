import { Box, Card, Divider, HStack, VStack } from "@chakra-ui/react";

function Title() {
	return (
		<HStack
			color="neon.500"
			align="center"
			justify="space-evenly"
			flex="1"
			spacing="2rem"
			className="my-4"
		>
			<Box className="flex gap-2 w-[115px]">
				<div>Time</div> <div>(s)</div>
			</Box>
			<Box className="flex gap-2 w-[115px]">
				<div>Height</div> <div>(ft)</div>
			</Box>
			<Box className="flex gap-2 w-[115px]">
				<div>Speed</div> <div>(mph)</div>
			</Box>
			<Box className="flex gap-2 w-[115px]">
				<div>Pitch</div> <div>(deg)</div>
			</Box>
			<Box className="flex gap-2 w-[115px]">
				<div>Roll</div> <div>(deg)</div>
			</Box>
			<Box className="flex gap-2 w-[115px]">
				<div>Fuel</div> <div>(lbs)</div>
			</Box>
		</HStack>
	);
}

type RowProps = {
	time: string;
	height: string;
	speed: string;
	pitch: string;
	roll: string;
	fuel: string;
};

function Row({ time, height, speed, pitch, roll, fuel }: RowProps) {
	return (
		<HStack
			color="neon.400"
			align="center"
			justify="space-evenly"
			flex="1"
			spacing="2rem"
			className="my-1"
		>
			<Box className="flex gap-2 w-[115px]">{time}</Box>
			<Box className="flex gap-2 w-[115px]">{height}</Box>
			<Box className="flex gap-2 w-[115px]">{speed}</Box>
			<Box className="flex gap-2 w-[115px] relative">{pitch}</Box>
			<Box className="flex gap-2 w-[115px]">{roll}</Box>
			<Box className="flex gap-2 w-[115px]">{fuel}</Box>
		</HStack>
	);
}

export type RowData = RowDataWithoutTime & {
	time: string;
};

export interface RowDataWithoutTime {
	height: string;
	speed: string;
	pitch: string;
	roll: string;
	fuel: string;
}

interface Props {
	rows: RowData[];
}

function Table({ rows }: Props) {
	return (
		<Card className="h-[360px]" variant="pixelated" fontSize="sm" overflow="auto">
			<div className="sticky z-10 top-0 left-0 right-0 bg-[#202F20] px-5">
				<Title />
				<Divider />
			</div>
			<VStack align="normal" position="relative" className=" py-1 px-5">
				{rows.map((row) => (
					<Row
						time={row.time}
						height={row.height}
						speed={row.speed}
						pitch={row.pitch}
						roll={row.roll}
						fuel={row.fuel}
					/>
				))}
			</VStack>
		</Card>
	);
}

export default Table;
