/** @type {import('tailwindcss').Config} */
export default {
	content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
	theme: {
		colors: {
			primary: "#11ED83",
			"primary-muted": "#157342",
			background: "#172217",
			brown: "#887837",
			accent: "#FBCB4A",
			alert: "#FB744A",
			secondary: "#202F20",
		},
		extend: {
			fontFamily: {
				body: `'dos-vga', san-serif`,
				heading: `'ppmondwest', san-serif`,
			},
		},
	},
	plugins: [],
};
