extends Node2D

func _ready():
	randomize()
	hand_out_cards()

func hand_out_cards():
	var i = $Table/Deck.size() / 2
	while i > 0:
		var card = $Table/Deck.pop_back()
		$Player/Hand.push_back(card)
		$Player/Hand.add_child(card)
		var card2 = $Table/Deck.pop_back()
		$Player2/Hand.push_back(card2)
		$Player2/Hand.add_child(card2)
		i -= 1
