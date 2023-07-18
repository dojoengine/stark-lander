import { useEffect, useState } from "react";
import Button from "./components/Button";
import { HStack } from "@chakra-ui/react";

import { KATANA_ACCOUNT_1_ADDRESS, setupNetwork } from "./dojo/setupNetwork";
import Table, { RowData } from "./components/Table";
import Control from "./components/Control";

const classHash = "0x48667cc1e24a07f65b4ce31d10fd9f6457d6451b0226433f8dc794c31c67b4f";

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
			height: "1000",
			pitch: "0",
			angle: "0",
			speed: "1000",
			time: "00:00",
		},
	]);

	const execute = function () {
		// setStage(Stage.Playing);

		setupNetwork()
			.execute("start", [])
			.catch((error) => {
				console.log(error);
			});
	};

	const call = function () {
		setupNetwork()
			.call(["8101821151424638830", ["0x0", KATANA_ACCOUNT_1_ADDRESS]])
			.then((result) => console.log("result", result))
			.catch((error) => {
				console.log(error);
			});
	};

	const burn = function () {
		setupNetwork()
			.execute("burn", [angle])
			.catch((error) => {
				console.log(error);
			});
	};

	const onIgnite = function () {
		// execute `burn` system
		console.log("onIgnite", angle);
	};

	const onChangeAngle = function (angle: number) {
		setAngle(angle);
		console.log("onChangeAngle", angle);
	};

	const onAddRow = function (data: RowData) {
		setRows((rows) => [...rows, data]);
		// go to bottom of table
	};

	useEffect(() => {
		if (stage !== Stage.Playing) return;

		// Initialize a web worker
		const myWorker = new Worker("worker.js");

		// Listen for messages from the worker
		myWorker.onmessage = function (e) {
			// console.log("Message received from worker", e.data);
			onAddRow(e.data as RowData);
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
						start
					</Button>
					<Button flex="1" onClick={() => call()}>
						call
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
