extends CanvasLayer

@export var game_scene: PackedScene

func _ready():
	pass

func _on_SingleGame_pressed():
	visible = false
	get_tree().paused = false
	if get_parent().has_node("Game"):
			get_parent().get_node("Game").queue_free()
			get_parent().remove_child(get_parent().get_node("Game"))
	var game = game_scene.instantiate()
	get_parent().add_child(game)


func _on_Quit_pressed():
	get_tree().quit()
