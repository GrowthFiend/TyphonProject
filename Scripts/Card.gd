extends Sprite

enum SUIT {HEART, DIAMONDS, CROSSES, SPADES}

const IMAGES_FOLDER_PATH = "res://Textures/Cards/Poker/"

const SUIT_NAMES = {
	SUIT.HEART: "hearts",
	SUIT.DIAMONDS: "diamonds",
	SUIT.CROSSES: "clubs",
	SUIT.SPADES: "spades",
}

const STRENGTH_NAMES = {
	11: "jack",
	12: "queen",
	13: "king",
	14: "ace",
}

var m_strength
var m_suit
var m_image_path

func init(strength, suit):
	m_strength = strength
	m_suit = suit
	m_image_path = get_image_path()
	if m_image_path:
		texture = load(m_image_path)
	else:
		print("Something wrong with %s and %s" % [m_strength, m_suit])

func get_strength():
	return m_strength

func get_suit():
	return m_suit

func get_image_path():
	if m_image_path:
		return m_image_path
	else:
		var converted_strength = m_strength
		var converted_suit
	
		if not m_strength in range(2, 15):
			return ""
		elif m_strength in STRENGTH_NAMES:
			converted_strength = STRENGTH_NAMES[m_strength]
		
		if not m_suit in SUIT_NAMES:
			return ""
		else:
			converted_suit = SUIT_NAMES[m_suit]
	
		var m_image_path = IMAGES_FOLDER_PATH + "%s_of_%s.png" % [converted_strength, converted_suit]
	
		if File.new().file_exists(m_image_path):
			return m_image_path
		else:
			print("Image was not found: ", m_image_path)
			return ""
