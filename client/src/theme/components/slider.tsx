import { cardPixelatedStyleOutset } from "../styles";

import { sliderAnatomy } from "@chakra-ui/anatomy";
import { createMultiStyleConfigHelpers } from "@chakra-ui/react";

import { generatePixelBorderPath } from "../../utils/ui";

const { definePartsStyle, defineMultiStyleConfig } = createMultiStyleConfigHelpers(
	sliderAnatomy.keys
);

const baseStyle = definePartsStyle({
	container: {
		// this will style the Slider component
	},
	track: {
		// this will style the SliderTrack component
		height: "3px",
		//...cardPixelatedStyle({radius:2}),
		...cardPixelatedStyleOutset({ borderImageWidth: 6, color: "#202F20" }),
	},
	thumb: {
		// this will style the SliderThumb component
		height: "23px",
		width: "23px",
		bg: "neon.200",
	},
	filledTrack: {
		// this will style the SliderFilledTrack component
		bg: "neon.700",
		height: "3px",
		borderRadius: 0,
		clipPath: `polygon(${generatePixelBorderPath(2, 2)})`,
	},
	mark: {
		// this will style the SliderMark component
	},
});
// export the base styles in the component theme
export const Slider = defineMultiStyleConfig({ baseStyle });
