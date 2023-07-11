// use orion::numbers::signed_integer::{integer_trait::IntegerTrait, i32::i32};
use debug::PrintTrait;
use cubit::types::fixed::{Fixed, FixedTrait, FixedAdd, FixedSub, FixedMul, FixedDiv, ONE_u128};
use cubit::types::vec2::{Vec2, Vec2Trait, Vec2Add, Vec2Sub, Vec2Mul, Vec2Div};
use cubit::math::trig::{cos, sin, PI_u128};
use traits::{TryInto, Into};

// Constants
const GRAVITY: u128 = 1; // Gravity force
const THRUST_FORCE: u128 = 1; // Thrust force applied on each update
const LANDER_WIDTH: u32 = 100; // Width of the lander
const LANDER_HEIGHT: u32 = 100; // Height of the lander
const LANDING_PAD_WIDTH: u32 = 1000; // Width of the landing pad
const LANDING_PAD_HEIGHT: u32 = 100; // Height of the landing pad
const MAX_VELOCITY_X: u32 = 50; // Maximum horizontal velocity
const MAX_VELOCITY_Y: u32 = 100; // Maximum vertical velocity
const MAX_ANGLE: u32 = 0; // Maximum rotation angle
const INITIAL_FUEL: u128 = 100; // Initial fuel amount
const FUEL_CONSUMPTION_RATE: u128 = 10; // Fuel consumption rate per second

#[derive(Copy, Drop)]
struct Lander {
    position: Vec2,
    velocity: Vec2,
    angle: Fixed,
    fuel: Fixed,
    thrust_angle: Fixed,
}

fn deg_to_rad(theta_deg: Fixed) -> Fixed {
    let pi = FixedTrait::new(PI_u128, false);
    let one_eighty = FixedTrait::new(180 * ONE_u128, false);
    theta_deg * pi / one_eighty
}

trait ILander {
    fn new(position: Vec2) -> Lander;
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

    fn new(position: Vec2) -> Lander {
        Lander {
            position: position, velocity: Vec2 {
                x: FixedTrait::new(1, false), y: FixedTrait::new(1, false)
            },
            angle: FixedTrait::new(0, false),
            fuel: FixedTrait::new(INITIAL_FUEL, false),
            thrust_angle: FixedTrait::new(0, false),
        }
    }

    fn update(
        ref self: Lander, thrust_felt: felt252, angle_deg_felt: felt252, delta_time_felt: felt252
    ) -> Lander {
        let thrust = FixedTrait::from_unscaled_felt(thrust_felt);
        let angle = deg_to_rad(FixedTrait::from_unscaled_felt(angle_deg_felt));
        let delta_time = FixedTrait::from_unscaled_felt(delta_time_felt);

        // downward force of gravity
        // let gravity_force = FixedTrait::new(GRAVITY.into(), true);
        let gravity_force = Vec2Trait::new(0, FixedTrait::new(GRAVITY, true));

        // let thrust_fixed = Fixed{mag: trust.mag.into(), sign: false};

        // let thrust_x = thrust * cos(angle);
        // let thrust_y = thrust * sin(angle);
        let thrust_force = Vec2Trait::new(thrust * cos(angle), thrust * sin(angle));

        // let thrust_force_x = thrust_x * FixedTrait::new(THRUST_FORCE, false);
        // let thrust_force_y = thrust_y * FixedTrait::new(THRUST_FORCE, false);

        // let total_force_x = thrust_force_x; // no other forces acting horizontally for now
        // let total_force_y = gravity_force + thrust_force_y;
        let total_force = gravity_force + thrust_force;

        // Update velocity
        // let delta_velocity_x = total_force.x * delta_time;
        // let delta_velocity_y = total_force.y * delta_time;
        let delta_velocity = Vec2Trait::new(total_force.x * delta_time, total_force.y * delta_time);

        // let old_velocity = self.velocity;

        // self.velocity.x = old_velocity.x + delta_velocity_x;
        // self.velocity.y = old_velocity.y + delta_velocity_y;
        self.velocity = self.velocity + delta_velocity

        // Update position

        // self.position.x = self.position.x + self.velocity.x * delta_time;
        // self.position.y = self.position.y + self.velocity.y * delta_time;

        let delta_position = Vec2Trait::new(velocity.x * delta_time, velocity.y * delta_time);

        // let old_position = self.position;

        // self.position.x = old_position.x + delta_position_x;
        // self.position.y = old_position.y + delta_position_y;
        self.position = self.position + delta_position

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
    let position = Vec2 {
        x: FixedTrait::new_unscaled(10, false), y: FixedTrait::new_unscaled(10000, false)
    };

    let mut lander = ImplLander::new(position);

    // negative thrust - 10 second burn
    lander
        .update(
            FixedTrait::new_unscaled(10, true),
            FixedTrait::new_unscaled(5, false),
            FixedTrait::new_unscaled(1, false)
        );

    FixedTrait::floor(lander.position.x).mag.print();
    FixedTrait::floor(lander.position.y).mag.print();
    lander.position.x.mag.print();
    lander.position.y.mag.print();

    lander.velocity.x.mag.print();
    lander.velocity.y.mag.print();

    lander.fuel.mag.print();
}
