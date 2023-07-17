import Button from "./components/Button";
import { Card, HStack } from "@chakra-ui/react";

import {setupNetwork } from "./dojo/setupNetwork";

function Body() {

	function execute(){
		setupNetwork().execute('start', []).catch((error) => {
			console.log(error);
		});
	}

	return (
		<div className="h-16 max-w-[720px] flex-1">
			{/* this is where u put all the main components */}
			<Button onClick={() => execute()}>Something</Button>
			<Card className="h-32 " variant={"pixelated"}></Card>
		</div>
	);
}

export default Body;
