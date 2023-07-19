import { useEffect, useState } from "react";
import Button from "./components/Button";

import { KATANA_ACCOUNT_1_ADDRESS, setupNetwork } from "./dojo/setupNetwork";
import Table, { RowData } from "./components/Table";
import Control from "./components/Control";
import { Lander, parseRawCalldataAsLander } from "./types/components";
import { Center, VStack } from "@chakra-ui/react";
import Prompt from "./components/Prompt";

enum Stage {
	Idle,
	Playing,
	End,
}

export enum EndState {
	Success,
	Failure,
}

function Body() {
	const [gameLoopWorker, setGameLoopWorker] = useState<Worker | null>(null);

	const [endState, setEndState] = useState<EndState | null>(null);
	const [stage, setStage] = useState<Stage>(Stage.Idle);

	// stores the game id for the current game
	const [gameId, setGameId] = useState(0);

	const [angle, setAngle] = useState<number>(0);
	const [rows, setRows] = useState<RowData[]>([]);

	// Handler for resetting the game state when
	// the game is over and the user wants to play again.
	const onNewGame = function () {
		setStage(Stage.Playing);
		setRows([
			{
				fuel: 100,
				height: 120000,
				pitch: 0,
				angle: 45,
				speed: 100,
				time: "00:00",
			},
		]);
	};

	// Handler for resetting the game state.
	const onResetGame = function () {
		setGameId((prev) => prev + 1);
		setStage(Stage.Idle);
		setEndState(null);
		setAngle(0);
	};

	// Handler for starting a new game.
	// A game is identified by the game id.
	const onStartGame = function () {
		setupNetwork()
			.execute("start", [])
			.then(onNewGame)
			.catch((error) => {
				console.log(error);
			});
	};

	// Handler for fetching the lander position of the current game.
	// The lander position is based on the current block timestamp.
	const onFetchLanderPosition = function (callback: (lander: Lander) => void) {
		setupNetwork()
			.call_execute(["8101821151424638830", [gameId, KATANA_ACCOUNT_1_ADDRESS]])
			.then((result) => {
				const data = result as string[];
				console.log("raw", data);
				callback(parseRawCalldataAsLander(data));
			})
			.catch((error) => {
				console.log("error on fetching lander position", error);
			});
	};

	const onIgnite = function () {
		const angle_mag = Math.abs(angle).toString();
		const angle_sign = angle >= 0 ? "0" : "1";

		setupNetwork()
			.execute("burn", ["0", "1", angle_mag, angle_sign, "1"])
			.then((result) => console.log("execute ", result))
			.catch((error) => {
				console.log("error on executing burn system", error);
			});
	};

	const onChangeAngle = function (angle: number) {
		setAngle(angle);
	};

	// Hanlder for adding more rows to the table.
	const onAddRow = function (data: RowData) {
		setRows((rows) => [...rows, data]);
	};

	// Fetch World uuid
	useEffect(() => {
		setupNetwork()
			.call("uuid", [])
			.then((result) => {
				const data = result as string;
				setGameId(parseInt(BigInt(data).toString()));
			})
			.catch((error) => {
				console.log("error in fetching World uuid", error);
			});
	}, []);

	useEffect(() => {
		console.log("stage", stage);
	}, [stage]);

	useEffect(() => {
		console.log("game id", gameId);
	}, [gameId]);

	useEffect(() => {
		if (stage !== Stage.Playing) return;

		const height = rows[rows.length - 1].height;
		const velocity = rows[rows.length - 1].speed;

		if (height <= 0 || velocity <= 0) {
			setStage(Stage.End);

			// only if the lander has landed properly
			// we can end the game in success.
			if (height === 0 && velocity === 0) {
				setEndState(EndState.Success);
			} else {
				setEndState(EndState.Failure);
			}
		}
	}, [stage, rows]);

	// Initialize the game loop
	useEffect(() => {
		if (stage !== Stage.Playing) {
			if (gameLoopWorker !== null) {
				gameLoopWorker.terminate();
				setGameLoopWorker(null);
			}

			return;
		}

		// Initialize a web worker
		const myWorker = new Worker("worker.js");

		// Listen for messages from the worker
		myWorker.onmessage = function (e) {
			onFetchLanderPosition((lander) => {
				onAddRow({
					time: e.data as string,
					speed: Math.abs(lander.velocity_y),
					angle: lander.angle,
					fuel: lander.fuel,
					height: lander.position_y,
					pitch: 0,
				});
			});
		};

		setGameLoopWorker(myWorker);
	}, [stage]);

	return (
		<div className=" max-w-[760px] flex-1">
			{/* this is where u put all the main components */}

			{stage === Stage.Idle && (
				<Center h="full">
					<Button w="full" onClick={() => onStartGame()}>
						Start
					</Button>
				</Center>
			)}

			{stage !== Stage.Idle && (
				<VStack>
					<Prompt gameEndState={endState} />
					<Table rows={rows} />
				</VStack>
			)}

			{stage == Stage.Playing && (
				<Control
					angle={angle}
					onChangeAngle={onChangeAngle}
					onIgnite={onIgnite}
				/>
			)}

			{stage === Stage.End && (
				<Button w="full" onClick={() => onResetGame()} className="mt-10">
					Retry
				</Button>
			)}
		</div>
	);
}

export default Body;
