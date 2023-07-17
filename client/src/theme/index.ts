// 1. Import `extendTheme`
import { extendTheme } from "@chakra-ui/react";
import * as Components from "./components";
import colors from "./colors";
import { styles, textStyles, layerStyles } from "./styles";

// 2. Call `extendTheme` and pass your custom values
const theme = extendTheme({
	colors,
	styles,
	textStyles,
	layerStyles,
	components: {
		...Components,
	},
});

export default theme;
