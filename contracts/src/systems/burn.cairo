#[system]
mod burn {
    use core::debug::PrintTrait;
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::Into;

    use dojo::world::Context;

    use cubit::f128::types::fixed::{
        Fixed, FixedTrait, FixedAdd, FixedSub, FixedMul, FixedDiv, ONE_u128
    };

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

        let key = player_id + game_id.into();

        // TODO: check auth

        // get current state
        let mut lander: Lander = get!(ctx.world, key, Lander);

        // assert fuel
        assert(lander.fuel > 0, 'no fuel');

        let elapsed = info.block_timestamp - lander.last_update;

        // since time has elapsed we need to find out where the lander actually is
        // then compute position based on elapsed time and last update
        let mut new_position = lander.position(elapsed);

        // convert to fixed math
        let thrust = FixedTrait::new_unscaled(thrust_felt, false);
        let angle = FixedTrait::new_unscaled(angle_deg_felt, angle_deg_sign);
        let delta_time = FixedTrait::new_unscaled(delta_time_felt, false);

        // burn!!
        let mut new = new_position.burn(thrust, angle, delta_time);

        new.fuel.print();

        // save new state of Lander
        set!(
            ctx.world,
            (Lander {
                key,
                last_update: new.last_update,
                position_x: new.position_x,
                position_x_sign: new.position_x_sign,
                position_y: new.position_y,
                position_y_sign: new.position_y_sign,
                velocity_x: new.velocity_x,
                velocity_x_sign: new.velocity_x_sign,
                velocity_y: new.velocity_y,
                velocity_y_sign: new.velocity_y_sign,
                angle: new.angle,
                angle_sign: new.angle_sign,
                fuel: new.fuel
            })
        );

        return ();
    }
}
