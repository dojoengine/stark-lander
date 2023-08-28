#[cfg(test)]
mod tests {
    use traits::{Into, TryInto};
    use core::result::ResultTrait;
    use array::{serialize_array_helper, ArrayTrait, SpanTrait};
    use option::OptionTrait;
    use box::BoxTrait;
    use clone::Clone;
    use debug::{print, PrintTrait};

    use starknet::testing;
    use starknet::{contract_address_const};

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::test_utils::spawn_test_world;

    use stark_lander::components::lander::{lander, Lander};
    use stark_lander::systems::burn::burn;
    use stark_lander::systems::start::start;
    use stark_lander::systems::position::position;

    use cubit::f128::types::fixed::{Fixed, FixedTrait};

    const STARTING_BLOCKTIME: u64 = 600;

    fn get_lander_entity(world: IWorldDispatcher, query: Array<felt252>) -> Lander {
        let mut raw_old_lander = world
            .entity('Lander'.into(), query.span(), 0, dojo::SerdeLen::<Lander>::len());

        let des = world.entity('Lander', query.span(), 0, dojo::SerdeLen::<Lander>::len());
        let mut _des = array::ArrayTrait::new();
        array::serialize_array_helper(query.span(), ref _des);
        array::serialize_array_helper(des, ref _des);
        let mut des = array::ArrayTrait::span(@_des);
        option::OptionTrait::expect(serde::Serde::<Lander>::deserialize(ref des), '{deser_err_msg}')
    }


    #[test]
    #[available_gas(30000000)]
    fn test_start() {
        testing::set_block_timestamp(STARTING_BLOCKTIME);

        testing::set_caller_address(contract_address_const::<0xb0b>());

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
        let start_call_data: Array<felt252> = Default::default();
        let mut res = world.execute('start'.into(), start_call_data);

        assert(res.len() > 0, 'did not spawn');

        let (game_id, player_id) = serde::Serde::<(u32, felt252)>::deserialize(ref res)
            .expect('create deserialization failed');

        let mut query: Array = Default::default();
        query.append(player_id + game_id.into());

        let old_lander = get_lander_entity(world, query);

        // old_lander.fuel.print();

        // shift time forward
        testing::set_block_timestamp(STARTING_BLOCKTIME + 10);

        let mut burn_call_data: Array = ArrayTrait::<felt252>::new();
        burn_call_data.append(game_id.into());
        burn_call_data.append(10.into());
        burn_call_data.append(0.into());
        burn_call_data.append(0.into());
        burn_call_data.append(5.into());

        let mut res = world.execute('burn'.into(), burn_call_data);

        testing::set_block_timestamp(STARTING_BLOCKTIME + 10);
        let mut query: Array = Default::default();
        query.append(player_id + game_id.into());

        let new_lander = get_lander_entity(world, query);

        // new_lander.fuel.print();
        // old_lander.fuel.print();

        assert(new_lander.fuel < old_lander.fuel, 'fuel did not burn');
    }
}
