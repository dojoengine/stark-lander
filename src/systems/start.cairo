// start new game - game starts immediately
// random velocity and position
// game is based on player address and incrementing game id
#[system]
mod Start {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::Into;

    use dojo::world::Context;

    use stark_lander::components::lander::Lander;
    use stark_lander::components::fuel::Fuel;

    fn execute(ctx: Context) -> (u32, felt252) {
        let info = starknet::get_block_info().unbox();

        let player_id: felt252 = ctx.origin.into();

        let game_id = ctx.world.uuid();

        let player_sk: Query = (game_id, player_id).into();

        // todo make rando
        set !(
            ctx.world,
            player_sk,
            (Lander {
                last_update: info.block_timestamp,
                position_x: 100,
                position_x_sign: false,
                position_y: 10000,
                position_y_sign: false,
                velocity_x: 1,
                velocity_x_sign: false,
                velocity_y: 1,
                velocity_y_sign: false,
                angle: 90,
                angle_sign: false,
                fuel: 100,
                fuel_sign: false,
            })
        );
        return (game_id, player_id);
    }
}