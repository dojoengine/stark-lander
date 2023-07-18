let startTime = new Date();
let seconds = 0;

setInterval(() => {
	const time = getTime();
	// send a message to notify for game loop
	self.postMessage(time);
}, 1000);

function getTime() {
	let now = new Date();
	let totalSeconds = Math.floor((now - startTime) / 1000);

	let minutes = Math.floor(totalSeconds / 60);
	let seconds = totalSeconds % 60;

	let timeString = `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(
		2,
		"0"
	)}`;

	return timeString;
}
