import BorderImage from "../components/icons/BorderImage";
import BorderImagePixelated from "../components/icons/BorderImagePixelated";

import { generatePixelBorderPath } from "../utils/ui";

export const styles = {
	global: {
		body: {
			height: "100vh",
			bgColor: "neon.900",
			color: "neon.200",
			letterSpacing: "0.04em",
			WebkitTapHighlightColor: "transparent",
		},
	},
};

// applied layerStyles below and also chakra's Card component
export const cardStyle = {
	position: "relative",
	color: "neon.200",
	bgColor: "none",
	borderStyle: "solid",
	borderWidth: "2px",
	borderImageSlice: "4",
	borderImageWidth: "4px",
	borderImageSource: `url("data:image/svg+xml,${BorderImage({
		color: "#157342",
		isPressed: false,
	})}")`,
};

// use clipPath to "cut" corners
export const cardPixelatedStyle = ({
	color = "#11ED83",
	pixelSize = 4,
	radius = 4,
}: {
	color?: string;
	pixelSize?: number;
	radius?: number;
}) => ({
	w: "full",
	bg: color,
	borderWidth: "0",
	borderRadius: "0",

	borderImageSource: "none",
	_hover: {
		borderImageSource: `none`,
	},
	_active: {
		top: 0,
		left: 0,
		borderImageSource: `none`,
	},
	clipPath: `polygon(${generatePixelBorderPath(radius, pixelSize)})`,
});

// use borderImage & borderImageOutset to display border with outset
export const cardPixelatedStyleOutset = ({
	color = "#11ED83",
	borderImageWidth = 8,
}: {
	color?: string;
	borderImageWidth?: number;
}) => ({
	w: "full",
	bg: color,
	borderWidth: "0",
	borderRadius: "0",
	borderImageWidth: `${borderImageWidth}px`,
	borderImageOutset: `${borderImageWidth}px`,
	borderImageSlice: 7,

	borderImageSource: `url("data:image/svg+xml,${BorderImagePixelated({
		color,
	})}")`,

	_hover: {
		borderImageSource: `url("data:image/svg+xml,${BorderImagePixelated({
			color,
		})}")`,
	},
	_active: {
		top: 0,
		left: 0,
		borderImageSource: `url("data:image/svg+xml,${BorderImagePixelated({
			color,
		})}")`,
	},
});

//layer styles
export const layerStyles = {
	card: cardStyle,
	rounded: {
		p: "6px",
		borderRadius: "6px",
		bgColor: "neon.700",
	},
	fill: {
		position: "absolute",
		top: "0",
		left: "0",
		boxSize: "full",
	},
};

//text styles
export const textStyles = {
	"upper-bold": {
		fontWeight: "700",
		textTransform: "uppercase",
	},
	subheading: {
		textTransform: "uppercase",
		fontFamily: "broken-console",
		letterSpacing: "0.25em",
	},
};
