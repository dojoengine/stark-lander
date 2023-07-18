// TODO: Abstract out Fuel from Lander Component
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Fuel {
    gallons: u128
}
