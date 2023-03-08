tool

extends "res://Scripts/CardPile.gd"
var Deck_config_parser = preload("res://Scripts/Utils/DeckConfigParser.gd")
var parser setget , get_parser

export(String, FILE, "*.yaml") var config_file = "res://Config/DeckPresets/TestDeck.yaml"
export(
	String,
	"full", "full_with_jockers", "small", "double", 
	"reds", "jokers", "spades", "no_spades", "with_images"
) var deck_name = "reds" setget set_deck

func _ready():
	get_parser()
	clear().populate(parser.get_ids(deck_name))
	
func draw_in_lines():
	var max_cards_in_line = 8
	var count = 0
	for card in _cards:
		card.z_index = count
		card.position.x = (count % max_cards_in_line) * 50
		card.position.y = ceil(count / max_cards_in_line) * 50
		count += 1

func set_deck(new_deck):
	deck_name = new_deck
	get_parser()
	parser.get_ids(deck_name)
	clear().populate(parser.get_ids(deck_name)).draw_in_lines()

func get_parser():
	if parser == null:
		parser = Deck_config_parser.new()
		parser.init(config_file)

	return parser
