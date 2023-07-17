import Stark from "../assets/svg/Stark";
import Icon from "../assets/svg/Icon";
import Lander from "../assets/svg/Lander";

function Header() {
	return (
		<div className="bg-secondary h-[64px] flex justify-center items-center">
			<div className="flex h-9 items-center ">
				<Stark />
				<Icon />
				<Lander />
			</div>
		</div>
	);
}

export default Header;
