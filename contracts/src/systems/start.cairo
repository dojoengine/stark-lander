// start new game - game starts immediately
// random velocity and position
// game is based on player address and incrementing game id
#[system]
mod start {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::Into;

    use dojo::world::Context;

    use cubit::types::fixed::{Fixed, FixedTrait};

    use stark_lander::components::lander::Lander;
    use stark_lander::components::fuel::Fuel;

    fn execute(ctx: Context) -> (u32, felt252) {
        let info = starknet::get_block_info().unbox();

        let player_id: felt252 = ctx.origin.into();

        let game_id = ctx.world.uuid();

        let player_sk: Query = (game_id, player_id).into();

        // TODO: make rando
        let position_x = FixedTrait::new_unscaled(1000, false);
        let position_y = FixedTrait::new_unscaled(12000, false);
        let velocity_x = FixedTrait::new_unscaled(100, false);
        let velocity_y = FixedTrait::new_unscaled(100, true);
        let angle = FixedTrait::new_unscaled(45, true);
        let fuel = FixedTrait::new_unscaled(10000, false);
        
        set !(
            ctx.world,
            player_sk,
            (Lander {
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
                fuel: fuel.mag,
                fuel_sign: fuel.sign,
            })
        );
        return (game_id, player_id);
    }
}

<<<<<<< HEAD
=======
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
    use stark_lander::systems::position::position;

    use cubit::types::fixed::{Fixed, FixedTrait};

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
        systems.append(position::TEST_CLASS_HASH);

        // deploy executor, world and register components/systems
        let world = spawn_test_world(components, systems);
        let start_call_data: Array = Default::default();
        let mut res = world.execute('start'.into(), start_call_data.span());

        assert(res.len() > 0, 'did not spawn');

        let (game_id, player_id) = serde::Serde::<(u32, felt252)>::deserialize(ref res)
            .expect('create deserialization failed');

        let mut raw_old_lander = world.entity('Lander'.into(), (game_id, player_id).into(), 0, dojo::SerdeLen::<Lander>::len());
        let old_lander = serde::Serde::<Lander>::deserialize(ref raw_old_lander)
                                .expect('Lander failed to deserialize');

        old_lander.fuel.print();

        let position_x = FixedTrait::new_unscaled(1000, false);
        let position_y = FixedTrait::new_unscaled(12000, false);
        let velocity_x = FixedTrait::new_unscaled(100, false);
        let velocity_y = FixedTrait::new_unscaled(100, false);
        let angle = FixedTrait::new_unscaled(0, false);
        let fuel = FixedTrait::new_unscaled(100, false);
        
        // assert(*lander[0] == STARTING_BLOCKTIME.into(), 'x is wrong');
        // assert(*lander[1] == position_x.mag.into(), 'x is wrong');
        // assert(*lander[2] == position_x.sign.unwrap().try_into(), 'x sign is wrong');
        // assert(*lander[3] == 12000, 'y is wrong');

        // shift time forward
        testing::set_block_timestamp(STARTING_BLOCKTIME + 10);

        let mut burn_call_data: Array = ArrayTrait::<felt252>::new();
        burn_call_data.append(game_id.into());
        burn_call_data.append(10.into());
        burn_call_data.append(0.into());
        burn_call_data.append(0.into());
        burn_call_data.append(5.into());

        let mut res = world.execute('burn'.into(), burn_call_data.span());

        let mut raw_new_lander = world.entity('Lander'.into(), (game_id, player_id).into(), 0, dojo::SerdeLen::<Lander>::len());
        let new_lander = serde::Serde::<Lander>::deserialize(ref raw_new_lander)
                                .expect('Lander failed to deserialize');

        assert(new_lander.fuel < old_lander.fuel, 'fuel did not burn');

        let mut position_call_data: Array = ArrayTrait::<felt252>::new();
        position_call_data.append(game_id.into());

        testing::set_block_timestamp(STARTING_BLOCKTIME + 4);

        // world.execute('position'.into(), position_call_data.span());

        // testing::set_block_timestamp(STARTING_BLOCKTIME + 4);

        // world.execute('position'.into(), position_call_data.span());

    }
}
>>>>>>> d7af2fd2f1122d6ee7f6b48b0f8c6c869be08bad
