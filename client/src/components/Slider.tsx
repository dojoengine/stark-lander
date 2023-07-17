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
import { useEffect, useState } from "react";

function Slider() {
	const [value, setValue] = useState(0);

	useEffect(() => {
		console.log("my value", value);
	}, [value]);

	const onDown = () => setValue(value - 1);

	const onUp = () => setValue(value + 1);

	return (
		<HStack className="py-3 justify-between">
			<Text width="120px">Roll:</Text>
			<Card
				variant={"pixelated"}
				width={"90px"}
				className="flex items-center justify-center h-[40px]"
			>
				{value}
			</Card>
			<ChakraSlider
				aria-label="slider-ex-1"
				defaultValue={0}
				width="300px"
				min={-180}
				max={180}
				value={value}
				className="mx-3"
				onChange={(value) => setValue(value)}
			>
				<SliderTrack>
					<SliderFilledTrack />
				</SliderTrack>
				<SliderThumb />
			</ChakraSlider>
			<HStack>
				<Box
					cursor="pointer"
					onClick={onDown}
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
					onClick={onUp}
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
