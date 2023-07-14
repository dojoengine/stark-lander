use box::BoxTrait;
use traits::Into;
use cubit::types::fixed::{Fixed, FixedTrait, FixedAdd, FixedSub, FixedMul, FixedDiv, ONE_u128};
use cubit::types::vec2::{Vec2, Vec2Trait, Vec2Add, Vec2Sub, Vec2Mul, Vec2Div};
use cubit::math::trig::{cos, sin, PI_u128};

use lander::ImplLanderMath;

// we keep position and velocity in same component so we can compute the position...
// TODO: might be better way to do this
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Lander {
    last_update: u64,
    position_x: u128,
    position_y: u128,
    velocity_x: u128,
    velocity_y: u128,
    angle: u128,
}

trait LanderTrait {
    fn position(ref self: Lander, elapsed: u64) -> Lander;
    fn has_landed(self: @Lander) -> bool;

    // converts stored values to a vector
    // fn to_vec(self: @Lander) -> Lander;
}

impl ImplLander of LanderTrait {
    fn position(ref self: Lander, elapsed: u64) -> Lander {
        let info = starknet::get_block_info().unbox();
        
        let position = Vec2 {
            x: FixedTrait::new_unscaled(10, false), y: FixedTrait::new_unscaled(10000, false)
        };

        let velocity = Vec2 { x: FixedTrait::new(0, false), y: FixedTrait::new(0, false) };

        let mut lander = ImplLanderMath::new(position, velocity, 45, 100);

       // last update - block number

       // if !landed and past 0 = ded
       // return lander
       self
    }
    fn has_landed(self: @Lander) -> bool {
        false
    }   
}