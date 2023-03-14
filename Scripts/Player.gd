extends Node2D

@export_enum("User", "Bot") var character : get = get_character, set = set_character
var is_retired = false

func _ready():
	$Name.text = name

func _on_Turn_pressed():
	pass

func update_hud():
	match character:
		"User":
			$Turn.visible = true
		"Bot":
			$Turn.visible = false

func set_character(new_character : String):
	if character == new_character:
		return
	character = new_character
	update_hud()

func get_character():
	return character
