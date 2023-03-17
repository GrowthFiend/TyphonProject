use godot::prelude::*;

mod test_class;

struct RustClasses;

#[gdextension]
unsafe impl ExtensionLibrary for RustClasses {}
