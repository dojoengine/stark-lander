import {
	Slider as ChakraSlider,
	SliderFilledTrack,
	SliderTrack,
	HStack,
	Text,
	Card,
	SliderThumb,
	Box,
} from "@chakra-ui/react";
import { ArrowEnclosed } from "./icons";

interface Props {
	angle: number;
	onChangeAngle: (angle: number) => void;
}

function Slider({ angle, onChangeAngle }: Props) {
	const onUp = (angle: number) => onChangeAngle(angle + 1);
	const onDown = (angle: number) => onChangeAngle(angle - 1);

	return (
		<HStack className="py-3 justify-between my-4">
			<Text width="120px">Roll:</Text>
			<Card
				variant={"pixelated"}
				width={"90px"}
				className="flex items-center justify-center h-[40px]"
			>
				{angle}
			</Card>
			<ChakraSlider
				aria-label="slider-ex-1"
				defaultValue={0}
				width="300px"
				min={-180}
				max={180}
				value={angle}
				className="mx-3"
				onChange={onChangeAngle}
			>
				<SliderTrack>
					<SliderFilledTrack />
				</SliderTrack>
				<SliderThumb />
			</ChakraSlider>
			<HStack>
				<Box
					cursor="pointer"
					onClick={() => onDown(angle - 1)}
					color="neon.500"
					_hover={{
						color: "neon.300",
					}}
				>
					<ArrowEnclosed
						direction="down"
						size="lg"
						width="35px"
						height="35px"
					/>
				</Box>
				<Box
					cursor="pointer"
					onClick={() => onUp(angle + 1)}
					color="neon.500"
					_hover={{
						color: "neon.300",
					}}
				>
					<ArrowEnclosed direction="up" size="lg" width="35px" height="35px" />
				</Box>
			</HStack>
		</HStack>
	);
}

export default Slider;
