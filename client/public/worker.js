let startTime = new Date();
let seconds = 0;

const intervalId = setInterval(() => {
	let now = new Date();
	let totalSeconds = Math.floor((now - startTime) / 1000);

	let minutes = Math.floor(totalSeconds / 60);
	let seconds = totalSeconds % 60;

	let timeString = `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(
		2,
		"0"
	)}`;

	self.postMessage({
		time: timeString,
		height: "999",
		speed: "1000",
		pitch: "0",
		roll: "0",
		fuel: "99",
	});
}, 1000);
