extends Node2D

func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		$Menu.visible = true
