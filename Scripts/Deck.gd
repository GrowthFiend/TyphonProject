extends "res://Scripts/CardPile.gd"
onready var Deck_config_parser = preload("res://Scripts/Utils/DeckConfigParser.gd")

export(String, FILE, "*.yaml") var config_file = "res://Config/DeckPresets/TestDeck.yaml"
export(String,
	"full", "full_with_jockers", "small", "double", 
	"reds", "jokers", "spades", "no_spades", "with_images") var use_deck = "reds"

func _ready():
	var parser = Deck_config_parser.new()
	parser.init(config_file)
	populate(parser.get_ids(use_deck))
	
func draw():
	var max_cards_in_line = 8
	var count = 0
	for card in _cards:
		card.z_index = count
		card.position.x = (count % max_cards_in_line) * 50
		card.position.y = ceil(count / max_cards_in_line) * 50
		count += 1
