tool

extends "res://Scripts/CardPile.gd"
var Deck_config_parser = preload("res://Scripts/Utils/DeckConfigParser.gd")
var parser setget , get_parser

# Вот эти 3 экспорта ниже потом должны браться из конфига или еще как-то передаваться сюда
# Сейчас это просто для демонстрации
export(String, FILE, "*.yaml") var config_file = "res://Config/DeckPresets/StandardDeck.yaml"
export(String,
	"full",
	"full_with_jockers",
	"small", 
	"double", 
	"reds",
	"jokers",
	"spades",
	"no_spades",
	"with_images"
) var deck_name = "reds" setget set_deck
export(String, 
	"FrenchSuited",
	 "zxyonitch",
	 "PixelFantasy"
) var style = "zxyonitch" setget set_style, get_style

func _ready():
	get_parser()
	print(deck_name)
	print(parser.get_ids(deck_name))
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

func set_style(s):
	style = s
	for card in _cards:
		card.style = style

func get_style():
	return style

const CARD_STEP = Vector2(0.2, 0.2) #логическое смещение в пикселях каждой последующей карты относительно предыдущей
const RENDER_STEP = Vector2(2, 2) #смещение в пикселях некоторой группы карт относительно предыдущей группы, для того, чтобы при рендере колоды ее края выглядели красиво

var m_cards = []


func init():
	m_cards.clear()
	return self
	
func init52():
	init()
	for strength in range(2, 15):
		for suit in range(0, 4):
			var card = card_scene.instance()
			card.init(strength, suit)
			card.position = position_by_num(strength*4+suit)
			m_cards.append(card)
			add_child(card)
	return self

func shuffle():
	m_cards.shuffle()
	update_cards_positions()
	return self

func position_by_num(number):
	var position = Vector2(100,100)
	return Vector2(position.x + RENDER_STEP.x*round(CARD_STEP.x*(number)/RENDER_STEP.x),position.y + RENDER_STEP.y*round(CARD_STEP.y*(number)/RENDER_STEP.y))

func update_cards_positions():
	var i = 0
	for card in m_cards:
		card.position = position_by_num(i)
		card.z_index = i
		i+=1

func size():
	return m_cards.size()
	
func pop_front():
	var card = m_cards.pop_front()
	remove_child(card)
	update_cards_positions()
	return card

func pop_back():
	var card = m_cards.pop_back()
	remove_child(card)
	update_cards_positions()
	return card

func push_front(card):
	m_cards.push_front(card)
	update_cards_positions()
	
func push_back(card):
	m_cards.push_back(card)
	update_cards_positions()

#переворачивает колоду целиком, то есть порядок кард инвертируется, а каждая карта переворачивается
func flip():
	m_cards.invert()
	for card in m_cards:
		card.flip()
	update_cards_positions()
	return self
	
func is_stake_ok():
	if size() > 1:
		return m_cards[size()-1].get_strength() >= m_cards[size() - 2].get_strength()
	else : return true
