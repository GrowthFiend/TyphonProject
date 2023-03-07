extends Node2D

func _ready():
	$Deck.init52().flip().shuffle()
	$Stake.init()
