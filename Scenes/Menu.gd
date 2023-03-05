extends Control

func _ready():
	set_position(Vector2(get_parent().get_parent().size.x/2, get_parent().get_parent().size.y/2))
