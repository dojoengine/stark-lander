import { useState } from "react";
import Button from "./components/Button";
import { Center } from "@chakra-ui/react";

import { setupNetwork } from "./dojo/setupNetwork";
import Game from "./Game";

const classHash = "0x48667cc1e24a07f65b4ce31d10fd9f6457d6451b0226433f8dc794c31c67b4f";

enum Stage {
	Idle,
	Playing,
}

function Body() {
	const [stage, setStage] = useState<Stage>(Stage.Idle);

	function execute() {
		setStage(Stage.Playing);

		setupNetwork()
			.execute("start", [])
			.catch((error) => {
				console.log(error);
			});
	}

	function call() {
		setupNetwork()
			.call(["8101821151424638830", ["0"]])
			.catch((error) => {
				console.log(error);
			});
	}

	return (
		<div className=" max-w-[760px] flex-1">
			{/* this is where u put all the main components */}

			{stage === Stage.Idle && (
				<Center className="mt-32">
					<Button onClick={() => execute()}>start</Button>
					<Button onClick={() => call()}>call</Button>
				</Center>
			)}

			{stage === Stage.Playing && <Game />}
		</div>
	);
}

export default Body;
