extends Node2D

func _ready():
	$Deck.init({
		"name": "full",
		"style": ["FrenchSuited", "PixelFantasy", "zxyonitch"].pick_random(),
	}).shuffle()
