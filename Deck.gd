extends Node2D

export(PackedScene) var card_scene

const CARD_STEP = Vector2(0.2, 0.2) #логическое смещение в пикселях каждой последующей карты относительно предыдущей
const RENDER_STEP = Vector2(2, 2) #смещение в пикселях некоторой группы карт относительно предыдущей группы, для того, чтобы при рендере колоды ее края выглядели красиво

var m_cards = []

func _ready():
	init52(50, 75)
	shuffle()
	pop_back()
	pop_front()
	flip()

func init(x, y):
	m_cards.clear()
	position = Vector2(x, y)
	
func init52(x, y):
	init(x, y)
	for strength in range(2, 15):
		for suit in range(0, 4):
			var card = card_scene.instance()
			card.init(strength, suit)
			card.position = position_by_num(strength*4+suit)
			m_cards.append(card)
			add_child(card)

func shuffle():
	m_cards.shuffle()
	update_cards_positions()

func position_by_num(number):
	return Vector2(position.x + RENDER_STEP.x*round(CARD_STEP.x*(number)/RENDER_STEP.x),position.y + RENDER_STEP.y*round(CARD_STEP.y*(number)/RENDER_STEP.y))

func update_cards_positions():
	var i = 0
	for card in m_cards:
		card.position = position_by_num(i)
		card.z_index = i
		i+=1

#пока эти методы просто удаляют верхнюю или нижнюю карту в колоде, нужно раскурить, как передавать ноды между сценами, чтобы функционал был таким каким нужно
func pop_front():
	var card = m_cards.pop_front()
	card.queue_free()
	update_cards_positions()
#пока эти методы просто удаляют верхнюю или нижнюю карту в колоде, нужно раскурить, как передавать ноды между сценами, чтобы функционал был таким каким нужно
func pop_back():
	var card = m_cards.pop_back()
	card.queue_free()
	update_cards_positions()

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
