extends ColorRect

func _ready():
	const SCALE = 4
	var p_size = get_parent().get_viewport_rect().size
	set_size(SCALE*p_size)
	set_position((1-SCALE)*p_size/2)
