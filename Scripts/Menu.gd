extends Control

func _ready():
	#set_position(Vector2(get_parent().get_parent().size.x/2, get_parent().get_parent().size.y/2))
	pass


func _on_SingleGame_pressed():
	visible = false


func _on_Quit_pressed():
	get_tree().quit()
