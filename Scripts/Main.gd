extends Node2D

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if has_node("Game"):
			if $Game.get_node("_TempTimer").is_stopped():
				$Game.get_node("_TempTimer").start()
				# если не делать игру невидимой, то получаем баг с z_index, когда кнопка отображается на верхнем леере, а нажимается на нижнем...
				$Game.visible = true
			else :
				$Game.get_node("_TempTimer").stop()
				# если не делать игру невидимой, то получаем баг с z_index, когда кнопка отображается на верхнем леере, а нажимается на нижнем...
				$Game.visible = false
			$Menu.visible = not $Menu.visible
