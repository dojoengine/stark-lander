import Button from "./components/Button";
import Slider from "./components/Slider";
import Table from "./components/Table";

import { setupNetwork } from "./dojo/setupNetwork";

const classHash = '0x48667cc1e24a07f65b4ce31d10fd9f6457d6451b0226433f8dc794c31c67b4f';

function Body() {

	function execute() {
		setupNetwork().execute('start', []).catch((error) => {
			console.log(error);
		});
	}

	function call() {

		setupNetwork().call(['position', 0]).catch((error) => {
			console.log(error);
		});
	}
	return (
		<div className=" max-w-[760px] flex-1">
			{/* this is where u put all the main components */}

			<Table />
			<Slider />
			<Button onClick={() => execute()}>start</Button>
			<Button onClick={() => call()}>call</Button>
			<Button w="full">Ignite</Button>
		</div>
	);
}

export default Body;
