use godot::engine::Area2D;
use godot::prelude::*;

#[derive(GodotClass)]
#[class(base=Area2D, init)]
pub struct TestClass {
    #[base]
    base: Base<Area2D>,
}

#[godot_api]
impl TestClass {

}

#[godot_api]
impl GodotExt for TestClass {

    fn ready(&mut self) {
        godot_print!("Hello World")
    }

}