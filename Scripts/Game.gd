extends Node2D

const PLAYERS_COUNT = 2
var m_turn = 0

func _ready():
	randomize()
	$Deck.init({
		"name": "full",
		"style": "FrenchSuited",
	}).shuffle()
	hand_out_cards()
	play()

func hand_out_cards():
	var i = $Deck.size()
	while i > 0:
		var card = $Deck.pop_back()
		var turn = i%PLAYERS_COUNT
		var current_player = "Player%s" % turn
		get_node(current_player).get_node("Hand").push_back(card)
		i -= 1

func play():
	var current_player = "Player%s" % m_turn
	get_node(current_player).get_node("Turn").visible = true

func change_turn():
	m_turn = (m_turn+1)%PLAYERS_COUNT
	play()
