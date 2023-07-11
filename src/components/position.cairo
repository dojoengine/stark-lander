#[derive(Component, Copy, Drop)]
struct Position {
    x: u128, 
    y: u128
}

// computed from Position and Velocity
// and used to update Position

#[derive(Component, Copy, Drop)]
struct Velocity {
    x: u128, 
    y: u128
}


#[derive(Component, Copy, Drop)]
struct Lander {
    id: u128
}

impl ImplLander of Lander {
    fn new(id: u128) -> Self {
        Self { id }
    }
}