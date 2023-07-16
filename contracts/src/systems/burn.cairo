#[system]
mod burn {
    use core::debug::PrintTrait;
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::Into;

    use dojo::world::Context;

    use stark_lander::components::lander::{Lander, LanderTrait};
    use stark_lander::components::fuel::Fuel;

    fn execute(
        ctx: Context,
        game_id: u32,
        thrust_felt: u128,
        angle_deg_felt: u128,
        angle_deg_sign: bool,
        delta_time_felt: u128
    ) {
        let info = starknet::get_block_info().unbox();

        let player_id: felt252 = ctx.origin.into();

        let player_sk: Query = (game_id, player_id).into();

        // TODO: check auth
        // TODO: check fuel

        // get current state
        let mut lander: Lander = get !(ctx.world, player_sk, Lander);

        let elapsed = info.block_timestamp - lander.last_update;

        // since time has elapsed we need to find out where the lander actually is
        // then compute position based on elapsed time and current state
        let mut new_position = lander.position(elapsed);

        // burn!!
        new_position.burn(thrust_felt, angle_deg_felt, angle_deg_sign, delta_time_felt);

        new_position.position_x.print();

        // save new state of Lander
        set !(ctx.world, player_sk, (lander));

        return ();
    }
}
