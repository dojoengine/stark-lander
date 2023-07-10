// use orion::numbers::signed_integer::{integer_trait::IntegerTrait, i32::i32};
use debug::PrintTrait;
use cubit::types::fixed::{Fixed, FixedTrait, FixedAdd, FixedSub, FixedMul, FixedDiv, ONE_u128};
use cubit::math::trig::{cos, sin};
use traits::{TryInto, Into};

// Constants
const GRAVITY: u32 = 1;  // Gravity force
const THRUST_FORCE: u128 = 1;  // Thrust force applied on each update
const LANDER_WIDTH: u32 = 100;  // Width of the lander
const LANDER_HEIGHT: u32 = 100;  // Height of the lander
const LANDING_PAD_WIDTH: u32 = 1000;  // Width of the landing pad
const LANDING_PAD_HEIGHT: u32 = 100;  // Height of the landing pad
const MAX_VELOCITY_X: u32 = 50;  // Maximum horizontal velocity
const MAX_VELOCITY_Y: u32 = 100;  // Maximum vertical velocity
const MAX_ANGLE: u32 = 0;  // Maximum rotation angle
const INITIAL_FUEL: u128 = 100;  // Initial fuel amount
const FUEL_CONSUMPTION_RATE: u128 = 10;  // Fuel consumption rate per second


#[derive(Copy, Drop)]
struct Position {
    x: Fixed,
    y: Fixed,
}

#[derive(Copy, Drop)]
struct Velocity {
    x: Fixed,
    y: Fixed,
}

#[derive(Copy, Drop)]
struct Lander {
    position: Position,
    velocity: Velocity,
    angle: Fixed,
    fuel: Fixed,
    thrust_angle: Fixed, 
}

trait ILander {
    fn new(position: Position) -> Lander;
    fn update(ref self: Lander, trust: Fixed, angle: Fixed, delta_time: Fixed) -> Lander;

    fn check_landed(ref self: Lander);
}

impl ImplLander of ILander {

    fn check_landed(ref self: Lander) {

        // Check if below y
        assert(self.position.y.mag <= 0, '');

        // check if within x
        assert(self.position.x.mag >= 0, '');
        assert(self.position.x.mag >= 100, '');

        // check if within velocity
        assert(self.velocity.x.mag <= 5, '');
        assert(self.velocity.y.mag <= 5, '');

        // check fuel
        assert(self.fuel.mag >= 0, '');

        // check angle
        // assert(self.position.x.mag >= 0, '')
    }

    fn new(position: Position) -> Lander{
        Lander {
            position: position,
            velocity: Velocity { x: FixedTrait::new(1, false), y: FixedTrait::new(1, false) },
            angle: FixedTrait::new(0, false),
            fuel: FixedTrait::new(INITIAL_FUEL, false),
            thrust_angle: FixedTrait::new(0, false),
        }
    }

    fn update(ref self: Lander, trust: Fixed, angle: Fixed, delta_time: Fixed) -> Lander {

        // downward force of gravity
        let gravity_force = FixedTrait::new(GRAVITY.into(), true);

        // let thrust_fixed = Fixed{mag: trust.mag.into(), sign: false};

        let thrust_x = trust * cos(angle);
        let thrust_y = trust * sin(angle);

        let thrust_force_x = thrust_x * FixedTrait::new(THRUST_FORCE, false);
        let thrust_force_y = thrust_y * FixedTrait::new(THRUST_FORCE, false);

        let total_force_x = thrust_force_x; // no other forces acting horizontally for now
        let total_force_y = gravity_force + thrust_force_y;

        // Update velocity
        let delta_velocity_x = total_force_x * delta_time;
        let delta_velocity_y = total_force_y * delta_time;

        let old_velocity = self.velocity;

        self.velocity.x = old_velocity.x + delta_velocity_x;
        self.velocity.y = old_velocity.y + delta_velocity_y;

        // Update position
        self.position.x = self.position.x + self.velocity.x * delta_time;
        self.position.y = self.position.y + self.velocity.y * delta_time;

        let fuel_consumption = FixedTrait::new(FUEL_CONSUMPTION_RATE, false);
        // Update fuel
        let fuel_consumed = fuel_consumption * delta_time;
        self.fuel -= fuel_consumed;

        self
    }
}

// #[test]
// #[available_gas(500000)]
// fn test_new_lander() {

//     let position = Position { x: IntegerTrait::<i32>::new(0, false), y: IntegerTrait::<i32>::new(0, false) };

//     let lander = ImplLander::new(position);

// }

#[test]
#[available_gas(500000000)]
fn test_update() {

    let position = Position { x: FixedTrait::new_unscaled(10, false), y: FixedTrait::new_unscaled(10000, false) };

    let mut lander = ImplLander::new(position);

    // negative thrust - 10 second burn
    lander.update(FixedTrait::new_unscaled(10, true), FixedTrait::new_unscaled(5, false), FixedTrait::new_unscaled(1, false));

    FixedTrait::floor(lander.position.x).mag.print();
    FixedTrait::floor(lander.position.y).mag.print();
    lander.position.x.mag.print();
    lander.position.y.mag.print();

    lander.velocity.x.mag.print();
    lander.velocity.y.mag.print();

    lander.fuel.mag.print();
    

}