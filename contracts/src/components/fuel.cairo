// TODO: Abstract out Fuel from Lander Component
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Fuel {
    #[key]
    key: felt252,
    gallons: u128
}
