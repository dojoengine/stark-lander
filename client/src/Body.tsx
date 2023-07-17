import Button from "./components/Button";
import { Card, HStack } from "@chakra-ui/react";

function Body() {
	return (
		<div className="h-16 max-w-[720px] flex-1">
			{/* this is where u put all the main components */}
			<Button>Something</Button>
			<Card className="h-32 " variant={"pixelated"}></Card>
		</div>
	);
}

export default Body;
