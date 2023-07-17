import type { ComponentMultiStyleConfig } from "@chakra-ui/theme";
import { cardStyle, cardPixelatedStyle } from "../styles";

export const Card: ComponentMultiStyleConfig = {
	parts: ["container", "header", "body", "footer"],
	baseStyle: {
		container: {
			...cardStyle,
		},
		header: {
			textAlign: "center",
		},
		body: {
			display: "flex",
			justifyContent: "center",
			alignContent: "center",
		},
		footer: {},
	},
	variants: {
		primary: {
			header: {
				py: "12px",
			},
			body: {
				p: "0",
			},
			footer: {
				px: "20px",
				py: "12px",
			},
		},
		pixelated: {
			container: {
				...cardPixelatedStyle({
					color: "neon.700",
				}),
			},
			// body: {
			// 	bg: "neon.700",
			// },
		},
	},
	defaultProps: {
		variant: "primary",
	},
};
