use debug::PrintTrait;
use cubit::types::fixed::{Fixed, FixedTrait, FixedAdd, FixedSub, FixedMul, FixedDiv, ONE_u128};
use cubit::types::vec2::{Vec2, Vec2Trait, Vec2Add, Vec2Sub, Vec2Mul, Vec2Div};
use cubit::math::trig::{cos, sin, PI_u128};
use traits::{TryInto, Into};

// Constants
const GRAVITY: u128 = 10; // Gravity force
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
struct LanderMath {
    position: Vec2,
    velocity: Vec2,
    angle: Fixed,
    fuel: Fixed
}

fn deg_to_rad(theta_deg: Fixed) -> Fixed {
    let pi = FixedTrait::new(PI_u128, false);
    let one_eighty = FixedTrait::new(180 * ONE_u128, false);
    theta_deg * pi / one_eighty
}

trait ILanderMath {
    fn new(position: Vec2, velocity: Vec2, angle: Fixed, fuel: Fixed) -> LanderMath;

    // adjusts the lander's position, velocity, and fuel based on the thrust and angle
    fn burn(
        ref self: LanderMath,
        thrust_felt: felt252,
        angle_deg_felt: felt252,
        delta_time_felt: felt252
    ) -> LanderMath;

    // returns the lander's position at the given time
    fn position(ref self: LanderMath, delta_time_felt: felt252) -> LanderMath;

    // wins if the lander is on the landing pad with a low enough velocity and angle
    fn check_landed(ref self: LanderMath) -> bool;

    fn print(ref self: LanderMath);
    fn print_unscaled(ref self: LanderMath);
}

impl ImplLanderMath of ILanderMath {
    fn new(position: Vec2, velocity: Vec2, angle: Fixed, fuel: Fixed) -> LanderMath {
        LanderMath {
            position,
            velocity,
            angle: angle,
            fuel: fuel
        }
    }
    fn burn(
        ref self: LanderMath,
        thrust_felt: felt252,
        angle_deg_felt: felt252,
        delta_time_felt: felt252
    ) -> LanderMath {
        let thrust = FixedTrait::from_unscaled_felt(thrust_felt);

        let angle = deg_to_rad(FixedTrait::from_unscaled_felt(angle_deg_felt));

        let delta_time = FixedTrait::from_unscaled_felt(delta_time_felt);

        // Update gravity -----------------------------

        let gravity_force = Vec2Trait::new(
            FixedTrait::new(0, false), FixedTrait::new_unscaled(GRAVITY, true)
        );

        // Update force -----------------------------

        let thrust_force = Vec2Trait::new(thrust * cos(angle), thrust * sin(angle));
        let total_force = gravity_force + thrust_force;

        // Update velocity -----------------------------

        let old_velocity = self.velocity;
        let delta_velocity = Vec2Trait::new(total_force.x * delta_time, total_force.y * delta_time);
        self.velocity = old_velocity + delta_velocity;

        // Update position -----------------------------
        let two = FixedTrait::new(2 * ONE_u128, false);
        let avg_velocity = Vec2Trait::new(
            (old_velocity.x + self.velocity.x) / two, (old_velocity.y + self.velocity.y) / two
        );
        let delta_position = Vec2Trait::new(
            avg_velocity.x * delta_time, avg_velocity.y * delta_time
        );
        self.position = self.position + delta_position;

        // Update fuel -----------------------------

        let fuel_consumption = FixedTrait::new(FUEL_CONSUMPTION_RATE, false);

        let fuel_consumed = fuel_consumption * delta_time;
        self.fuel -= fuel_consumed;
        self.angle = FixedTrait::from_unscaled_felt(angle_deg_felt);

        self
    }
    fn position(ref self: LanderMath, delta_time_felt: felt252) -> LanderMath {
        let delta_time = FixedTrait::from_unscaled_felt(delta_time_felt);

        // Update gravity -----------------------------

        let gravity_force = Vec2Trait::new(
            FixedTrait::new(0, false), FixedTrait::new_unscaled(GRAVITY, true)
        );

        // Update force -----------------------------
        // let thrust_force = Vec2Trait::new(cos(self.angle), sin(self.angle));
        let total_force = gravity_force;

        // Update velocity -----------------------------
        let old_velocity = self.velocity;
        let delta_velocity = Vec2Trait::new(total_force.x * delta_time, total_force.y * delta_time);
        self.velocity = old_velocity + delta_velocity;

        // Update position -----------------------------
        let two = FixedTrait::new(2 * ONE_u128, false);
        let avg_velocity = Vec2Trait::new(
            (old_velocity.x + self.velocity.x) / two, (old_velocity.y + self.velocity.y) / two
        );
        let delta_position = Vec2Trait::new(
            avg_velocity.x * delta_time, avg_velocity.y * delta_time
        );
        self.position = self.position + delta_position;

        self
    }
    fn check_landed(ref self: LanderMath) -> bool {
        // check if the lander is on the landing pad with a low enough velocity and angle
        true
    }
    fn print(ref self: LanderMath) {
        self.position.x.mag.print();
        self.position.x.sign.print();
        self.position.y.mag.print();
        self.position.y.sign.print();

        self.velocity.x.mag.print();
        self.velocity.x.sign.print();
        self.velocity.y.mag.print();
        self.velocity.y.sign.print();

        self.angle.mag.print();
        self.angle.sign.print();

        self.fuel.mag.print();
        self.fuel.sign.print();
    }

    fn print_unscaled(ref self: LanderMath) {
        (self.position.x.mag / ONE_u128).print();
        (self.position.x.sign).print();
        (self.position.y.mag / ONE_u128).print();
        self.position.y.sign.print();

        (self.velocity.x.mag / ONE_u128).print();
        self.velocity.x.sign.print();
        (self.velocity.y.mag / ONE_u128).print();
        self.velocity.y.sign.print();

        (self.angle.mag / ONE_u128).print();
        self.angle.sign.print();
    }
}

#[test]
#[available_gas(500000000)]
fn test_update() {
    let position = Vec2 {
        x: FixedTrait::new_unscaled(1000, false), y: FixedTrait::new_unscaled(12000, false)
    };

    let velocity = Vec2 {
        x: FixedTrait::new_unscaled(100, false), y: FixedTrait::new_unscaled(100, true)
    };

    let mut lander = ImplLanderMath::new(position, velocity, FixedTrait::new(45, false), FixedTrait::new(100, false));

    lander.burn(5, -45, 5);

    lander.print_unscaled();

    // (lander.position.x.mag).print();
    // lander.position.x.sign.print();

    // (lander.position.y.mag).print();
    // lander.position.y.sign.print();

    // (lander.velocity.x.mag).print();
    // lander.velocity.x.sign.print();

    // (lander.velocity.y.mag).print();
    // lander.velocity.y.sign.print();

    lander.position(10);
// lander.print_unscaled();

// (lander.position.x.mag).print();
// lander.position.x.sign.print();

// (lander.position.y.mag).print();
// lander.position.y.sign.print();

// (lander.velocity.x.mag).print();
// lander.velocity.x.sign.print();

// (lander.velocity.y.mag).print();
// lander.velocity.y.sign.print();
}
