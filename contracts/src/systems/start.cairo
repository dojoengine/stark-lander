// start new game - game starts immediately
// random velocity and position
// game is based on player address and incrementing game id
#[system]
mod start {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::Into;

    use dojo::world::Context;

    use cubit::f128::types::fixed::{Fixed, FixedTrait};

    use stark_lander::components::lander::Lander;
    use stark_lander::components::fuel::Fuel;
    use debug::PrintTrait;
    fn execute(ctx: Context) -> (u32, felt252) {
        let info = starknet::get_block_info().unbox();

        let player_id: felt252 = ctx.origin.into();

        let game_id = ctx.world.uuid();
        let key = player_id + game_id.into();

        // TODO: make rando
        let position_x = FixedTrait::new_unscaled(1000, false);
        let position_y = FixedTrait::new_unscaled(120000, false);
        let velocity_x = FixedTrait::new_unscaled(1, false);
        let velocity_y = FixedTrait::new_unscaled(1, true);
        let angle = FixedTrait::new_unscaled(90, true);

        set!(
            ctx.world,
            (Lander {
                key,
                last_update: info.block_timestamp,
                position_x: position_x.mag,
                position_x_sign: position_x.sign,
                position_y: position_y.mag,
                position_y_sign: position_y.sign,
                velocity_x: velocity_x.mag,
                velocity_x_sign: velocity_x.sign,
                velocity_y: velocity_y.mag,
                velocity_y_sign: velocity_y.sign,
                angle: angle.mag,
                angle_sign: angle.sign,
                fuel: 10000
            })
        );
        return (game_id, player_id);
    }
}

