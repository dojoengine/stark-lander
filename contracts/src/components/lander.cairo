use core::debug::PrintTrait;
use lander_math::math::{ImplLanderMath, ILanderMath, LanderMath};
use box::BoxTrait;
use traits::Into;
use cubit::types::fixed::{Fixed, FixedTrait, FixedAdd, FixedSub, FixedMul, FixedDiv, ONE_u128};
use cubit::types::vec2::{Vec2, Vec2Trait, Vec2Add, Vec2Sub, Vec2Mul, Vec2Div};
use cubit::math::trig::{cos, sin, PI_u128};

// TODO: Make multiple components for the lander
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Lander {
    last_update: u64,
    position_x: u128,
    position_x_sign: bool,
    position_y: u128,
    position_y_sign: bool,
    velocity_x: u128,
    velocity_x_sign: bool,
    velocity_y: u128,
    velocity_y_sign: bool,
    angle: u128,
    angle_sign: bool,
    fuel: u128,
    fuel_sign: bool,
}

trait LanderTrait {
    // computed position
    fn position(ref self: Lander, elapsed: u64) -> Lander;

    // burn adjustment
    fn burn(ref self: Lander, thrust: Fixed, angle_deg: Fixed, delta_time: Fixed) -> Lander;

    // check within range
    fn has_landed(self: @Lander) -> bool;

    // convert to math struct
    fn to_math(self: @Lander) -> LanderMath;
}

impl ImplLander of LanderTrait {
    fn burn(ref self: Lander, thrust: Fixed, angle_deg: Fixed, delta_time: Fixed) -> Lander {
        let info = starknet::get_block_info().unbox();

        let mut landerMath = self.to_math();

        landerMath.burn(thrust, angle_deg, delta_time);

        landerMath.print_unscaled();

        Lander {
            last_update: info.block_timestamp,
            position_x: landerMath.position.x.mag,
            position_x_sign: landerMath.position.x.sign,
            position_y: landerMath.position.y.mag,
            position_y_sign: landerMath.position.y.sign,
            velocity_x: landerMath.velocity.x.mag,
            velocity_x_sign: landerMath.velocity.x.sign,
            velocity_y: landerMath.velocity.y.mag,
            velocity_y_sign: landerMath.velocity.y.sign,
            angle: landerMath.angle.mag,
            angle_sign: landerMath.angle.sign,
            fuel: landerMath.fuel.mag,
            fuel_sign: landerMath.fuel.sign,
        }
    }
    fn position(ref self: Lander, elapsed: u64) -> Lander {
        let mut landerMath = self.to_math();

        // we calculate the position of the lander according to the elapsed time from the library
        landerMath.position(FixedTrait::new_unscaled(elapsed.into(), false));

        // landerMath.print_unscaled();

        Lander {
            last_update: self.last_update,
            position_x: landerMath.position.x.mag,
            position_x_sign: landerMath.position.x.sign,
            position_y: landerMath.position.y.mag,
            position_y_sign: landerMath.position.y.sign,
            velocity_x: landerMath.velocity.x.mag,
            velocity_x_sign: landerMath.velocity.x.sign,
            velocity_y: landerMath.velocity.y.mag,
            velocity_y_sign: landerMath.velocity.y.sign,
            angle: self.angle,
            angle_sign: self.angle_sign,
            fuel: self.fuel,
            fuel_sign: self.fuel_sign,
        }
    }
    // TODO: check if the lander is within the landing zone
    fn has_landed(self: @Lander) -> bool {
        let info = starknet::get_block_info().unbox();

        // check if the lander is within the landing zone
        let mut landerMath = self.to_math();

        if (landerMath.position.y.mag > 0) {
            return false;
        }

        let current_position = landerMath
            .position(
                FixedTrait::new_unscaled((info.block_timestamp - *self.last_update).into(), false)
            );

        if (current_position.position.y.mag < 0) {
            return false;
        }    

        true
    }
    fn to_math(self: @Lander) -> LanderMath {
        let position = Vec2 {
            x: FixedTrait::new(*self.position_x, *self.position_x_sign),
            y: FixedTrait::new(*self.position_y, *self.position_y_sign)
        };

        let velocity = Vec2 {
            x: FixedTrait::new(*self.velocity_x, *self.velocity_x_sign),
            y: FixedTrait::new(*self.velocity_y, *self.velocity_y_sign)
        };

        let angle = FixedTrait::new(*self.angle, *self.angle_sign);

        let fuel = FixedTrait::new(*self.fuel, *self.fuel_sign);

        ImplLanderMath::new(position, velocity, angle, fuel)
    }
}
