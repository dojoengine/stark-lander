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

fn gravity(gravity: u128) -> Vec2 {
    Vec2Trait::new(FixedTrait::new(0, false), FixedTrait::new_unscaled(gravity, true))
}

trait ILanderMath {
    fn new(position: Vec2, velocity: Vec2, angle: Fixed, fuel: Fixed) -> LanderMath;

    // adjusts the lander's position, velocity, and fuel based on the thrust and angle
    fn burn(ref self: LanderMath, thrust: Fixed, angle_deg: Fixed, delta_time: Fixed) -> LanderMath;

    // returns the lander's position at the given time
    fn position(ref self: LanderMath, delta_time: Fixed) -> LanderMath;

    fn print(ref self: LanderMath);
    fn print_unscaled(ref self: LanderMath);
}

impl ImplLanderMath of ILanderMath {
    fn new(position: Vec2, velocity: Vec2, angle: Fixed, fuel: Fixed) -> LanderMath {
        LanderMath { position, velocity, angle, fuel }
    }
    fn burn(
        ref self: LanderMath, thrust: Fixed, angle_deg: Fixed, delta_time: Fixed
    ) -> LanderMath {

        let angle = deg_to_rad(angle_deg);

        // Update gravity -----------------------------

        let gravity_force = gravity(GRAVITY);

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

        let fuel_consumption = FixedTrait::new_unscaled(FUEL_CONSUMPTION_RATE, false);

        self.fuel -= fuel_consumption * delta_time;

        // self.fuel.mag.print();
        // self.fuel.sign.print();

        // overflow fuel check
        if(self.fuel.sign == true) {
            self.fuel = FixedTrait::new(0, false);
        }
        
        self.angle = angle_deg;

        self
    }
    fn position(ref self: LanderMath, delta_time: Fixed) -> LanderMath {

        // Update gravity -----------------------------
        let gravity_force = gravity(GRAVITY);

        // Update force -----------------------------
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

        (self.fuel.mag / ONE_u128).print();
        self.fuel.sign.print();
    }
}

#[test]
#[available_gas(500000000)]
fn test_update() {
    let position = Vec2 {
        x: FixedTrait::new_unscaled(1000, false), y: FixedTrait::new_unscaled(12000, false)
    };

    let velocity = Vec2 {
        x: FixedTrait::new_unscaled(0, false), y: FixedTrait::new_unscaled(10, true)
    };

    let angle = FixedTrait::new_unscaled(45, true);
    let fuel = FixedTrait::new_unscaled(10000, false);

    let mut lander = ImplLanderMath::new(position, velocity, angle, fuel);

    let thrust = FixedTrait::new_unscaled(10, false);
    let delta_time_burn = FixedTrait::new_unscaled(20, false);

    let angle = FixedTrait::new_unscaled(45, true);

    lander.burn(thrust, angle, delta_time_burn);
    let delta_time_position = FixedTrait::new_unscaled(10, false);
    lander.position(delta_time_position);
    lander.print_unscaled();

    lander.burn(thrust, angle, delta_time_burn);
    let delta_time_position = FixedTrait::new_unscaled(10, false);
    lander.position(delta_time_position);
    lander.print_unscaled();
}
