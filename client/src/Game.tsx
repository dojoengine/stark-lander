import { useEffect, useState } from "react";
import Prompt from "./components/Prompt";
import Table, { RowData } from "./components/Table";
import Control from "./components/Control";

function Game() {
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
	}, []);

	return (
		<>
			<Prompt />
			<Table rows={rows} />
			<Control angle={angle} onChangeAngle={onChangeAngle} onIgnite={onIgnite} />
		</>
	);
}

export default Game;
