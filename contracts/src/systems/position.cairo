#[system]
mod position {
    use core::debug::PrintTrait;
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::Into;

    use dojo::world::Context;

    use cubit::types::fixed::{Fixed, FixedTrait, FixedAdd, FixedSub, FixedMul, FixedDiv, ONE_u128};

    use stark_lander::components::lander::{Lander, LanderTrait};
    use stark_lander::components::fuel::Fuel;

    fn execute(ctx: Context, game_id: u32) -> Lander {
        let info = starknet::get_block_info().unbox();

        let player_id: felt252 = ctx.origin.into();

        let player_sk: Query = (game_id, player_id).into();

        // get current state
        let mut lander: Lander = get !(ctx.world, player_sk, Lander);

        let elapsed = info.block_timestamp - lander.last_update;

        lander.position(elapsed)
    }
}
