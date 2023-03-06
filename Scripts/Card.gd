extends Sprite

var m_strength
var m_suit
var m_image_path

func init(strength, suit):
	m_strength = strength
	m_suit = suit
	m_image_path = pair_to_resource(strength, suit)
	if m_image_path:
		texture = load(m_image_path)
	else:
		print("Something wrong with %s and %s" % [strength, suit])

func get_strength():
	return m_strength

func get_suit():
	return m_suit

func get_image_path():
	return m_image_path

func pair_to_resource(strength, suit):
	var converted_strength = strength
	var converted_suit
	
	if not strength in range(2, 15):
		return ""
	elif strength in Globals.STRENGTH_NAMES:
		converted_strength = Globals.STRENGTH_NAMES[strength]
		
	if not suit in Globals.SUIT_NAMES:
		return ""
	else:
		converted_suit = Globals.SUIT_NAMES[suit]
	
	var m_image_path = Globals.IMAGES_FOLDER_PATH + "%s_of_%s.png" % [converted_strength, converted_suit]
	
	if File.new().file_exists(m_image_path):
		return m_image_path
	else:
		print("Image was not found: ", m_image_path)
		return ""
