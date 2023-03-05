extends ColorRect

func _ready():
	set_size(Vector2(get_parent().get_viewport_rect().size.x, get_parent().get_viewport_rect().size.y))

