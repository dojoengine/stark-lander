#[system]
mod position {
    use core::debug::PrintTrait;
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::Into;
    use starknet::ContractAddress;

    use dojo::world::Context;

    use stark_lander::components::lander::{Lander, LanderTrait};
    use stark_lander::components::fuel::Fuel;

    fn execute(ctx: Context, game_id: u32, player_id: ContractAddress) -> Lander {
        // block
        let info = starknet::get_block_info().unbox();

        let player_id: felt252 = player_id.into();

        // define query
        let key = player_id + game_id.into();

        // get current state
        let mut lander: Lander = get!(ctx.world, key, Lander);

        // get elapsed between last update
        let elapsed = info.block_timestamp - lander.last_update;

        // compute position according to time
        let mut new_position = lander.position(elapsed);

        new_position
    }
}
