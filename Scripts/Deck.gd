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
	update_deck()
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
		clear().populate(parser.get_ids(deck_name))
		update_cards_positions()
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


const CARD_STEP = Vector2(0.2, 0.2) #логическое смещение в пикселях каждой последующей карты относительно предыдущей
const RENDER_STEP = Vector2(2, 2) #смещение в пикселях некоторой группы карт относительно предыдущей группы, для того, чтобы при рендере колоды ее края выглядели красиво

func shuffle():
	_cards.shuffle()
	update_cards_positions()
	return self

func position_by_num(number):
	var pos = Vector2(0, 0)
	return Vector2(pos.x + RENDER_STEP.x*round(CARD_STEP.x*(number)/RENDER_STEP.x),pos.y + RENDER_STEP.y*round(CARD_STEP.y*(number)/RENDER_STEP.y))

func update_cards_positions():
	var i = 0
	for card in _cards:
		card.position = position_by_num(i)
		card.z_index = i
		i+=1
	return self

func size():
	return _cards.size()
	
func pop_front():
	var card = _cards.pop_front()
	remove_child(card)
	update_cards_positions()
	return card

func pop_back():
	var card = _cards.pop_back()
	remove_child(card)
	update_cards_positions()
	return card

func push_front(card):
	_cards.push_front(card)
	update_cards_positions()
	
func push_back(card):
	_cards.push_back(card)
	update_cards_positions()

#переворачивает колоду целиком, то есть порядок кард инвертируется, а каждая карта переворачивается
func flip():
	_cards.reverse()
	for card in _cards:
		card.flip()
	update_cards_positions()
	return self
	
func is_stake_ok():
	if size() > 1:
		return calculate_sthength(_cards[size()-1]) >= calculate_sthength(_cards[size() - 2])
	else : return true

func calculate_sthength(card):
	match card.get_rank():
		"2": return 2
		"3": return 3
		"4": return 4
		"5": return 5
		"6": return 6
		"7": return 7
		"8": return 8
		"9": return 9
		"10": return 10
		"jack": return 11
		"queen": return 12
		"king": return 13
		"ace": return 14
		"joker": return 15
