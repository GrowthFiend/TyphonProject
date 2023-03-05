extends Node2D

export(PackedScene) var card_scene

func _ready():
	randomize()
	add_card(randi() % 13 + 2, randi() % Globals.SUIT.size())

func _on__TempTimer_timeout():
	add_card(randi() % 13 + 2, randi() % Globals.SUIT.size())

func add_card(strength: int, suit):
	var card = card_scene.instance()
	card.init(strength, suit)
	card.position = Vector2(randi() % 1000, randi() % 500)
	card.rotate(randf() * TAU)
	add_child(card)	
