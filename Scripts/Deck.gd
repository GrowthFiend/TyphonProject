@tool

extends CardPile
var parser : get = get_parser


# Вот эти 3 экспорта ниже потом должны браться из конфига или еще как-то передаваться сюда
# Сейчас это просто для демонстрации
@export var config_file : String # (String, FILE, "*.yaml")
@export_enum("full", "full_with_jockers", "small", "double", "reds", "jokers", "spades", "no_spades", "with_images") var deck_name : set = set_deck
@export_enum("FrenchSuited", "zxyonitch", "PixelFantasy") var style : get = get_style, set = set_style
@export_enum("Stake3D", "Fan", "One_on_one", "Roughly") var appearance: get = get_appearance, set = set_appearance

const STAKE3D_CARD_STEP = Vector2(0.6, 0.6) #логическое смещение в пикселях каждой последующей карты относительно предыдущей
const STAKE3D_RENDER_STEP = Vector2(3, 3) #смещение в пикселях некоторой группы карт относительно предыдущей группы, для того, чтобы при рендере колоды ее края выглядели красиво
const FAN_RADIUS = 700
const FAN_FI_STEP = 2*PI*2/360


func _ready():
	randomize()
	appearance = "Stake3D"

func transform_by_num(card, number):
	var pos = get_parent().position
	var rot = get_parent().rotation
	var target_pos
	var target_rot
	match appearance:
		"Stake3D":
			card.need_update_target = true
			target_pos = Vector2(pos.x + STAKE3D_RENDER_STEP.x*round(STAKE3D_CARD_STEP.x*(number)/STAKE3D_RENDER_STEP.x),pos.y + STAKE3D_RENDER_STEP.y*round(STAKE3D_CARD_STEP.y*(number)/STAKE3D_RENDER_STEP.y))
			target_rot = rot
		"Fan":
			card.need_update_target = true
			var fi = FAN_FI_STEP*number - FAN_FI_STEP*_cards.size()/2 + rot
			target_pos = Vector2(pos.x + FAN_RADIUS*cos(fi- PI/2) + FAN_RADIUS*sin(rot), pos.y + FAN_RADIUS*sin(fi - PI/2) + FAN_RADIUS*cos(rot)) #TODO
			target_rot = fi#TODO
		"One_on_one":
			target_pos = Vector2(pos.x ,pos.y)
			target_rot = rot
		"Roughly":
			target_pos = Vector2(pos.x + randi()%100-50 ,pos.y+ randi()%100-50)
			target_rot = rot + PI*(randi()%360)/360+PI/2
	if card.need_update_target:
			card.target_position = target_pos
			card.target_rotation = target_rot
			card.z_index = number+z_index
			card.need_update_target = false

			
	
func update_card_targets():
	var i = 0
	for card in _cards:
		transform_by_num(card, i)
		i+=1
	return self

func _process(zella):
	pass

func init(params):
	if params.has("name") and params["name"]:
		deck_name = params["name"]
	
	if params.has("style") and params["style"]:
		style = params["style"]
	update_deck()
	return self
	
func before_add_card(card):
	card.style = style
	card.is_open = false
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
		clear().populate(parser.get_ids(deck_name)).update_card_targets()
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

func set_appearance(new_appearance : String):
	if appearance == new_appearance:
		return
	appearance = new_appearance
	for card in _cards:
		card.appearance = appearance
		card.update_view()
	update_card_targets()
		
func get_appearance():
	return appearance



# --- Физические методы общие для всех стопок ---

func shuffle():
	_cards.shuffle()
	update_card_targets()
	return self

func size():
	return _cards.size()
	
func pop_front():
	var card = _cards.pop_front()
	update_card_targets()
	return card

func pop_back():
	var card = _cards.pop_back()
	update_card_targets()
	return card

func push_front(card):
	_cards.push_front(card)
	card.need_update_target = true
	update_card_targets()
	
func push_back(card):
	_cards.push_back(card)
	card.need_update_target = true
	update_card_targets()

#переворачивает колоду целиком, то есть порядок кард инвертируется, а каждая карта переворачивается
func flip():
	_cards.reverse()
	for card in _cards:
		card.flip()
	return self



# --- Методы стопок только для игры "Пьяница"---

func is_stake_ok():
	if size() > 1:
		return calculate_sthength(_cards[size()-1]) >= calculate_sthength(_cards[size() - 2])
	else : return true

func calculate_sthength(card):
	match card.rank:
		"jack": return 11
		"queen": return 12
		"king": return 13
		"ace": return 14
		"joker": return 15
		_: return int(card.rank)
