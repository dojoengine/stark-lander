import { useEffect, useState } from "react";
import Button from "./components/Button";
import { HStack } from "@chakra-ui/react";

import { KATANA_ACCOUNT_1_ADDRESS, setupNetwork } from "./dojo/setupNetwork";
import Table, { RowData } from "./components/Table";
import Control from "./components/Control";
import { Lander, parseRawCalldataAsLander } from "./types/components";

enum Stage {
	Idle,
	Playing,
}

function Body() {
	const [stage, setStage] = useState<Stage>(Stage.Idle);

	const [angle, setAngle] = useState<number>(0);
	const [rows, setRows] = useState<RowData[]>([
		{
			fuel: "100",
			height: "120000",
			pitch: "0",
			angle: "45",
			speed: "100",
			time: "00:00",
		},
	]);

	const execute = function () {
		setStage(Stage.Playing);

		setupNetwork()
			.execute("start", [])
			.catch((error) => {
				console.log(error);
			});
	};

	const call = function (callback: (lander: Lander) => void) {
		setupNetwork()
			.call(["8101821151424638830", ["0", KATANA_ACCOUNT_1_ADDRESS]])
			.then((result) => {
				const data = result as string[];
				console.log("raw", data);
				callback(parseRawCalldataAsLander(data));
			})
			.catch((error) => {
				console.log(error);
			});
	};

	const onIgnite = function () {
		const angle_mag = Math.abs(angle).toString();
		const angle_sign = angle >= 0 ? "0" : "1";

		setupNetwork()
			.execute("burn", ["0", "10", angle_mag, angle_sign, "1"])
			.then((result) => console.log("execute ", result))
			.catch((error) => {
				console.log(error);
			});
	};

	const onChangeAngle = function (angle: number) {
		setAngle(angle);
		console.log("onChangeAngle", angle);
	};

	const onAddRow = function (data: RowData) {
		setRows((rows) => [...rows, data]);
	};

	// Initialize the game loop
	useEffect(() => {
		if (stage !== Stage.Playing) return;

		// Initialize a web worker
		const myWorker = new Worker("worker.js");

		// Listen for messages from the worker
		myWorker.onmessage = function (e) {
			// onAddRow(e.data as RowData);
			call((lander) => {
				onAddRow({
					time: e.data as string,
					speed: lander.velocity_y.toString(),
					angle: lander.angle.toString(),
					fuel: lander.fuel.toString(),
					height: lander.position_y.toString(),
					pitch: "0",
				});
			});
		};

		// Make sure to terminate the worker when you're done with it
		return () => {
			myWorker.terminate();
		};
	}, [stage]);

	return (
		<div className=" max-w-[760px] flex-1">
			{/* this is where u put all the main components */}

			<Table rows={rows} />

			{stage === Stage.Idle && (
				<HStack className="my-10">
					<Button flex="1" onClick={() => execute()}>
						Start
					</Button>
				</HStack>
			)}

			{stage == Stage.Playing && (
				<Control
					angle={angle}
					onChangeAngle={onChangeAngle}
					onIgnite={onIgnite}
				/>
			)}
		</div>
	);
}

export default Body;
