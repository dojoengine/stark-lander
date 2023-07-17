import Button from "./components/Button";
import Slider from "./components/Slider";
import Table from "./components/Table";

function Body() {
	return (
		<div className=" max-w-[760px] flex-1">
			{/* this is where u put all the main components */}
			<Table />
			<Slider />
			<Button w="full">Ignite</Button>
		</div>
	);
}

export default Body;
