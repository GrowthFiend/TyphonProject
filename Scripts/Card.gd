extends Sprite

enum SUIT {HEART, DIAMONDS, CROSSES, SPADES}

const IMAGES_FOLDER_PATH = "res://Textures/Cards/Poker/"
const FACE_DOWN_IMAGE_PATH = IMAGES_FOLDER_PATH + "face_down.png"

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
var m_flipped

func init(strength, suit):
	m_strength = strength
	m_suit = suit
	m_flipped = false
	m_image_path = get_image_path()
	if not m_image_path:
		printerr("Something wrong with %s and %s" % [m_strength, m_suit])
	render()
		
func render():
	if m_flipped:
		texture = load(FACE_DOWN_IMAGE_PATH)
	else:
		texture = load(m_image_path)

func flip():
	m_flipped = not m_flipped
	render()

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
	
		m_image_path = IMAGES_FOLDER_PATH + "%s_of_%s.png" % [converted_strength, converted_suit]
	
		if File.new().file_exists(m_image_path):
			return m_image_path
		else:
			printerr("Image was not found: ", m_image_path)
			return ""
