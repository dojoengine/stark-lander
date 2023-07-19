import { EndState } from "../Body";
import Skull from "../assets/svg/Skull";
import Face from "../assets/svg/HappyFace";
import { HStack, Card, Center } from "@chakra-ui/react";

interface Props {
	gameEndState: EndState | null;
}

function Prompt({ gameEndState }: Props) {
	return (
		<HStack className="mb-8" w="full" align="normal" spacing="8">
			<Card h="72px" w="86px">
				<Center h="full">
					{gameEndState === EndState.Failure ? <Skull /> : <Face />}
				</Center>
			</Card>

			<Card variant="pixelated" className="px-6">
				<Center h="full">
					{gameEndState === null &&
						"That's one small step for a man, one giant leap for provable gaming."}

					{gameEndState === EndState.Success &&
						"In space, no one can hear you clap, but I certainly can!"}

					{gameEndState === EndState.Failure &&
						"Moon rocks called: they're filing a complaint about your landing technique."}
				</Center>
			</Card>
		</HStack>
	);
}

export default Prompt;
