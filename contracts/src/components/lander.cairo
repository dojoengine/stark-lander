use core::debug::PrintTrait;
use lander_math::math::{ImplLanderMath, ILanderMath, LanderMath};
use box::BoxTrait;
use option::OptionTrait;
use traits::{Into, TryInto};
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
    fuel: u128
}

trait LanderTrait {
    // computed position
    fn position(ref self: Lander, elapsed: u64) -> Lander;

    // burn adjustment
    fn burn(ref self: Lander, thrust: Fixed, angle_deg: Fixed, delta_time: Fixed) -> Lander;

    // check within range
    fn has_landed(self: @Lander, elapsed: u64) -> bool;

    // convert to math struct
    fn to_math(self: @Lander) -> LanderMath;
}

impl ImplLander of LanderTrait {
    fn burn(ref self: Lander, thrust: Fixed, angle_deg: Fixed, delta_time: Fixed) -> Lander {
        let info = starknet::get_block_info().unbox();

        let mut landerMath = self.to_math();

        landerMath.burn(thrust, angle_deg, delta_time);

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
            fuel: landerMath.fuel.try_into().unwrap()
        }
    }
    fn position(ref self: Lander, elapsed: u64) -> Lander {
        let mut landerMath = self.to_math();

        // we calculate the position of the lander according to the elapsed time from the library
        landerMath.position(FixedTrait::new_unscaled(elapsed.into(), false));

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
            fuel: self.fuel
        }
    }
    // TODO: check if the lander is within the landing zone
    // TODO: check if within velocity range
    fn has_landed(self: @Lander, elapsed: u64) -> bool {
        let mut landerMath = self.to_math();

        let current_position = landerMath.position(FixedTrait::new_unscaled(elapsed.into(), false));

        if (current_position.position.y.sign == false) {
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

        let fuel = FixedTrait::new_unscaled(*self.fuel, false);

        ImplLanderMath::new(position, velocity, angle, fuel)
    }
}


#[test]
#[available_gas(500000000)]
fn check_landed() {
    let position_x = FixedTrait::new_unscaled(1000, false);
    let position_y = FixedTrait::new_unscaled(12000, false);
    let velocity_x = FixedTrait::new_unscaled(1, false);
    let velocity_y = FixedTrait::new_unscaled(1, true);
    let angle = FixedTrait::new_unscaled(90, true);
    let fuel = FixedTrait::new_unscaled(10000, false);

    let mut lander = Lander {
        last_update: 1000,
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
        fuel: fuel.try_into().unwrap()
    };

    // has not landed
    assert(!lander.has_landed(1), 'has not landed');

    // has landed or exploded
    assert(lander.has_landed(100), 'has not landed');
}


#[test]
#[available_gas(500000000)]
fn check_burn() {
    let position_x = FixedTrait::new_unscaled(1000, false);
    let position_y = FixedTrait::new_unscaled(12000, false);
    let velocity_x = FixedTrait::new_unscaled(1, false);
    let velocity_y = FixedTrait::new_unscaled(1, true);
    let angle = FixedTrait::new_unscaled(90, true);
    let fuel = FixedTrait::new_unscaled(10000, false);

    let mut lander = Lander {
        last_update: 1000,
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
        fuel: fuel.try_into().unwrap()
    };

    let thrust = FixedTrait::new_unscaled(1, false);
    let angle = FixedTrait::new_unscaled(45, false);
    let delta_time = FixedTrait::new_unscaled(10, false);

    let burnt = lander.burn(thrust, angle, delta_time);

    assert(lander.fuel > burnt.fuel, 'no fuel burnt');
}
