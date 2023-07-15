use traits::{Into, TryInto};
use core::result::ResultTrait;
use array::{ArrayTrait, SpanTrait};
use option::OptionTrait;
use box::BoxTrait;
use clone::Clone;
use debug::PrintTrait;

use starknet::{ContractAddress, syscalls::deploy_syscall};
use starknet::class_hash::{ClassHash, Felt252TryIntoClassHash};
use dojo::database::query::{IntoPartitioned, IntoPartitionedQuery};
use dojo::interfaces::{
    IComponentLibraryDispatcher, IComponentDispatcherTrait, ISystemLibraryDispatcher,
    ISystemDispatcherTrait
};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use dojo::test_utils::spawn_test_world;

use stark_lander::components::lander::{lander, Lander};

use stark_lander::systems::burn::Burn;
use stark_lander::systems::start::Start;

fn spawn_game() -> (ContractAddress, u32, felt252) {
    let mut components = array::ArrayTrait::new();
    components.append(lander::TEST_CLASS_HASH);

    let mut systems = array::ArrayTrait::new();
    systems.append(Burn::TEST_CLASS_HASH);
    systems.append(Start::TEST_CLASS_HASH);

    let world = spawn_test_world(components, systems);

    let mut spawn_game_calldata = array::ArrayTrait::<felt252>::new();

    let mut res = world.execute('start'.into(), spawn_game_calldata.span());

    assert(res.len() > 0, 'did not spawn');

    let (game_id, player_id) = serde::Serde::<(u32, felt252)>::deserialize(ref res)
        .expect('spawn deserialization failed');
        

    // let mut res = world.entity('Game'.into(), game_id.into(), 0, dojo::SerdeLen::<Game>::len());
    // assert(res.len() > 0, 'game not found');

    // let game = serde::Serde::<Game>::deserialize(ref res).expect('game deserialization failed');
    // assert(game.start_time == START_TIME, 'start time mismatch');
    // assert(game.max_players == MAX_PLAYERS, 'max players mismatch');
    // assert(game.max_turns == MAX_TURNS, 'max turns mismatch');
    // assert(game.is_finished == false, 'game is finished mismatch');

    (world.contract_address, game_id, player_id)
}

// fn spawn_player(world_address: ContractAddress, game_id: felt252) -> felt252 {
//     let world = IWorldDispatcher { contract_address: world_address };

//     let mut spawn_player_calldata = array::ArrayTrait::<felt252>::new();
//     spawn_player_calldata.append(game_id);

//     let mut res = world.execute('join_game'.into(), spawn_player_calldata.span());
//     assert(res.len() > 0, 'did not spawn');

//     let player_id = serde::Serde::<felt252>::deserialize(ref res)
//         .expect('spawn deserialization failed');

//     let mut res = world.entity('Player'.into(), (game_id, player_id).into(), 0, 0);
//     assert(res.len() > 0, 'player not found');

//     let player = serde::Serde::<Player>::deserialize(ref res)
//         .expect('player deserialization failed');

//     assert(player.health == 100, 'health mismatch');
//     assert(player.cash == 100 * SCALING_FACTOR, 'cash mismatch');
//     player_id
// }


#[test]
#[available_gas(100000000)]
fn test_create_game() {
    let (world_address, game_id, _) = spawn_game();

    // let brooklyn_id: felt252 = 'Brooklyn'.into();
    // let res = IWorldDispatcher {
    //     contract_address: world_address
    // }
    //     .entity(
    //         'Location'.into(), (game_id, brooklyn_id).into(), 0, dojo::SerdeLen::<Location>::len()
    //     );
    // assert(res.len() > 0, 'no Brooklyn location');

    // let queens_id: felt252 = 'Queens'.into();
    // let res = IWorldDispatcher {
    //     contract_address: world_address
    // }.entity('Location'.into(), (game_id, queens_id).into(), 0, dojo::SerdeLen::<Location>::len());
    // assert(res.len() > 0, 'no queens location');

    // let (players, _) = IWorldDispatcher {
    //     contract_address: world_address
    // }.entities('Player'.into(), game_id.into(), 0);
    // assert(players.len() == 1, 'wrong num players');
}