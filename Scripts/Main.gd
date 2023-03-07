extends Node2D

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if has_node("Game"):
			get_tree().paused = not get_tree().paused
			$Menu.visible = not $Menu.visible
