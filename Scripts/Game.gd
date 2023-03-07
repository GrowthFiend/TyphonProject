extends Node2D
export(PackedScene) var card_scene

func _ready():
	randomize()

func _on__TempTimer_timeout():
	add_card(randi() % 13 + 2, randi() % 4)
	
func _process(delta):
	pass

func add_card(strength: int, suit):
	var card = card_scene.instance()
	card.init(strength, suit)
	card.flip()
	if strength == 5:
		card.flip()
	card.position = Vector2(randi() % 1920, randi() % 1080)
	card.rotate(randf() * TAU)
	add_child(card)
