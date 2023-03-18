extends Camera2D

var target_zoom = Vector2(1, 1)
var speed = 2*GLOBAL.GAME_SPEED

func _ready():
	position = get_parent().get_viewport_rect().size/2


func _process(delta):
		if zoom != target_zoom:
			zoom = lerp(zoom, target_zoom, speed*delta)
