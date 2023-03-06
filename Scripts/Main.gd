extends Node2D

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if has_node("Game"):
			if $Game.get_node("_TempTimer").is_stopped():
				$Game.get_node("_TempTimer").start()
			else :
				$Game.get_node("_TempTimer").stop()
			$Menu.visible = not $Menu.visible
