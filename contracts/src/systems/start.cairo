// start new game - game starts immediately
// random velocity and position
// game is based on player address and incrementing game id
#[system]
mod start {
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
                position_x: 1000,
                position_x_sign: false,
                position_y: 12000,
                position_y_sign: false,
                velocity_x: 100,
                velocity_x_sign: false,
                velocity_y: 100,
                velocity_y_sign: false,
                angle: 0,
                angle_sign: false,
                fuel: 100,
                fuel_sign: false,
            })
        );
        return (game_id, player_id);
    }
}

#[cfg(test)]
mod tests {
    use traits::{Into, TryInto};
    use core::result::ResultTrait;
    use array::{ArrayTrait, SpanTrait};
    use option::OptionTrait;
    use box::BoxTrait;
    use clone::Clone;
    use debug::PrintTrait;

    use starknet::testing;

    use dojo::world::IWorldDispatcherTrait;

    use dojo::test_utils::spawn_test_world;

    use stark_lander::components::lander::{lander, Lander};

    use stark_lander::systems::burn::burn;
    use stark_lander::systems::start::start;

    const STARTING_BLOCKTIME: u64 = 600;

    #[test]
    #[available_gas(30000000)]
    fn test_start() {
        testing::set_block_timestamp(STARTING_BLOCKTIME);

        let caller = starknet::contract_address_const::<0x0>();

        // components
        let mut components: Array = Default::default();
        components.append(lander::TEST_CLASS_HASH);

        // systems
        let mut systems: Array = Default::default();
        systems.append(burn::TEST_CLASS_HASH);
        systems.append(start::TEST_CLASS_HASH);

        // deploy executor, world and register components/systems
        let world = spawn_test_world(components, systems);
        let start_call_data: Array = Default::default();
        let mut res = world.execute('start'.into(), start_call_data.span());

        assert(res.len() > 0, 'did not spawn');

        let (game_id, player_id) = serde::Serde::<(u32, felt252)>::deserialize(ref res)
            .expect('create deserialization failed');

        let lander = world.entity('Lander'.into(), (game_id, player_id).into(), 0, dojo::SerdeLen::<Lander>::len());
        
        assert(*lander[0] == STARTING_BLOCKTIME.into(), 'x is wrong');
        assert(*lander[1] == 1000, 'x is wrong');
        assert(*lander[2] == 0, 'x sign is wrong');
        assert(*lander[3] == 12000, 'y is wrong');

        testing::set_block_timestamp(STARTING_BLOCKTIME + 1000);


        let mut burn_call_data: Array = ArrayTrait::<felt252>::new();
        burn_call_data.append(game_id.into());
        burn_call_data.append(5.into());
        burn_call_data.append(45.into());
        burn_call_data.append(1.into());
        burn_call_data.append(5.into());

        let mut res = world.execute('burn'.into(), burn_call_data.span());


        let new_lander = world.entity('Lander'.into(), (game_id, player_id).into(), 0, dojo::SerdeLen::<Lander>::len());
        
        assert(*new_lander[0] != STARTING_BLOCKTIME.into(), 'x is wrong');
        assert(*new_lander[1] != 100, 'x is wrong');
        assert(*new_lander[2] != 0, 'x sign is wrong');
        assert(*new_lander[3] == 10000, 'y is wrong');

    }
}
