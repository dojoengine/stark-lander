import Button from "./components/Button";
import Slider from "./components/Slider";

function Body() {
	return (
		<div className=" max-w-[720px] flex-1">
			{/* this is where u put all the main components */}
			<Slider />
			<Button w="full">Ignite</Button>
		</div>
	);
}

export default Body;
