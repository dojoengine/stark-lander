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

    fn execute(ctx: Context) {
        let info = starknet::get_block_info().unbox();

        let player_id: felt252 = ctx.origin.into();

        let game_id = ctx.world.uuid();

        let player_sk: Query = (game_id, player_id).into();

        // todo make rando
        set !(
            ctx.world,
            player_sk,
            (
                Fuel {
                    gallons: 1000
                    }, Lander {
                    last_update: info.block_timestamp,
                    position_x: 100,
                    position_y: 10000,
                    velocity_x: 1,
                    velocity_y: 1,
                    angle: 90,
                }
            )
        );
        return ();
    }
}


#[system]
mod Burn {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::Into;

    use dojo::world::Context;

    use stark_lander::components::lander::{Lander, LanderTrait};
    use stark_lander::components::fuel::Fuel;

    fn execute(ctx: Context, game_id: u32) {
        let info = starknet::get_block_info().unbox();

        let player_id: felt252 = ctx.origin.into();

        let player_sk: Query = (game_id, player_id).into();

        // TODO: check auth
        // TODO: check fuel

        // get current state
        let mut lander: Lander = get !(ctx.world, player_sk, Lander);

        let elapsed = info.block_timestamp - lander.last_update;

        // compute position based on elapsed time and current state
        let mut current_lander_position = lander.position(elapsed);

        // compute new velocity based on elapsed time and current state
        // compute new fuel

        // save new state of Lander

        return ();
    }
}
