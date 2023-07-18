import Button from "./Button";
import Slider from "./Slider";

interface Props {
	angle?: number;
	onIgnite: () => void;
	onChangeAngle: (angle: number) => void;
}

function Control({ angle, onChangeAngle, onIgnite }: Props) {
	return (
		<>
			<Slider angle={angle} onChangeAngle={onChangeAngle} />
			<Button w="full" onClick={onIgnite}>
				Ignite
			</Button>
		</>
	);
}

export default Control;
