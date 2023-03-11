@tool

extends CardPile
var parser : get = get_parser

# Вот эти 3 экспорта ниже потом должны браться из конфига или еще как-то передаваться сюда
# Сейчас это просто для демонстрации
@export var config_file : String # (String, FILE, "*.yaml")
@export_enum("full", "full_with_jockers", "small", "double", "reds", "jokers", "spades", "no_spades", "with_images") var deck_name : set = set_deck
@export_enum("FrenchSuited", "zxyonitch", "PixelFantasy") var style : get = get_style, set = set_style

func init(params):
	if params.has("name") and params["name"]:
		deck_name = params["name"]
	
	if params.has("style") and params["style"]:
		style = params["style"]
	
	return self
	
func before_add_card(card):
	card.style = style
	return card
	
func draw_in_lines():
	var max_cards_in_line = 8
	var count = 0
	for card in _cards:
		card.z_index = count
		card.position.x = (count % max_cards_in_line) * 50
		@warning_ignore("integer_division")
		card.position.y = ceil(count / max_cards_in_line) * 50
		count += 1

func update_deck():
	if config_file and deck_name and style:
		clear().populate(parser.get_ids(deck_name)).draw_in_lines()
	return self

func set_deck(new_deck_name : String):
	if new_deck_name != deck_name:
		deck_name = new_deck_name
		update_deck()

func get_parser():
	if parser == null:
		parser = DeckConfigParser.new()
		parser.init(config_file)
	return parser

func set_style(new_style : String):
	if style == new_style:
		return
	
	style = new_style
	for card in _cards:
		card.style = style
		card.update_view()

func get_style():
	return style
