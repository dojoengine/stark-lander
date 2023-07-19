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

        // old_lander.fuel.print();
        
        // shift time forward
        testing::set_block_timestamp(STARTING_BLOCKTIME + 10);

        let mut burn_call_data: Array = ArrayTrait::<felt252>::new();
        burn_call_data.append(game_id.into());
        burn_call_data.append(10.into());
        burn_call_data.append(0.into());
        burn_call_data.append(0.into());
        burn_call_data.append(5.into());

        let mut res = world.execute('burn'.into(), burn_call_data.span());

        testing::set_block_timestamp(STARTING_BLOCKTIME + 10);

        let mut raw_new_lander = world.entity('Lander'.into(), (game_id, player_id).into(), 0, dojo::SerdeLen::<Lander>::len());
        let new_lander = serde::Serde::<Lander>::deserialize(ref raw_new_lander)
                                .expect('Lander failed to deserialize');

        new_lander.fuel.print();
        old_lander.fuel.print();

        assert(new_lander.fuel < old_lander.fuel, 'fuel did not burn');

    }
}
