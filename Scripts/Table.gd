extends Node2D

func _ready():
	$Deck.init({
		"name": "full",
		"style": "FrenchSuited",
	}).shuffle()
#	$Deck.init52().flip().shuffle()
#	$Stake.init()
