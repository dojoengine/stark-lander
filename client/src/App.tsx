import Header from "./components/Header";
import Body from "./Body";

function App() {
	return (
		<div className="font-body min-h-screen flex flex-col">
			<Header />
			<div className="flex-1 flex justify-center py-20">
				<Body />
			</div>
		</div>
	);
}

export default App;
