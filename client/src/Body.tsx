import Button from "./components/Button";
import Slider from "./components/Slider";
import Table from "./components/Table";

import {setupNetwork } from "./dojo/setupNetwork";

function Body() {

	function execute(){
		setupNetwork().execute('start', []).catch((error) => {
			console.log(error);
		});
	}

	return (
		<div className=" max-w-[760px] flex-1">
			{/* this is where u put all the main components */}
			
			<Table />
			<Slider />
			<Button onClick={() => execute()}>start</Button>
			<Button w="full">Ignite</Button>
		</div>
	);
}

export default Body;
