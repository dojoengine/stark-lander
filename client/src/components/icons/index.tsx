import { Icon as ChakraIcon, IconProps as ChakraIconProps } from "@chakra-ui/react";
import { ThemingProps } from "@chakra-ui/styled-system";
import React from "react";

export interface IconProps extends ChakraIconProps, ThemingProps {}

export const Icon = ({
	children,
	...rest
}: { children: React.ReactElement<SVGPathElement> } & IconProps) => {
	return (
		<ChakraIcon viewBox="0 0 36 36" fill="currentColor" {...rest}>
			{children}
		</ChakraIcon>
	);
};

export * from "./Arrow";
export * from "./ArrowEnclosed";
export * from "./ArrowInput";
