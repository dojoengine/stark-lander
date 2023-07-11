use box::BoxTrait;
use traits::Into;

// we keep position and velocity in same component so we can compute the position...
// TODO: might be better way to do this
#[derive(Component, Copy, Drop)]
struct Lander {
    last_update: u128,
    position_x: u128,
    position_y: u128,
    velocity_x: u128,
    velocity_y: u128,
    angle: u128,
}

trait LanderTrait {
    fn position(ref self: Lander) -> Lander;
    fn has_landed(self: @Lander) -> bool;

    // converts stored values to a vector
    // fn to_vec(self: @Lander) -> Lander;
}

impl ImplLander of LanderTrait {
    fn position(ref self: Lander) -> Lander {
        let info = starknet::get_block_info().unbox();
        
       // last update - block number

       // if !landed and past 0 = ded
       // return lander
       self
    }
    fn has_landed(self: @Lander) -> bool {
        false
    }   
}