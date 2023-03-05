extends Control

const images_folder_path = "res://Textures/Cards/Poker/"

var suit_names = {
	Globals.SUIT.HEART: "hearts",
	Globals.SUIT.DIAMONDS: "diamonds",
	Globals.SUIT.CROSSES: "clubs",
	Globals.SUIT.SPADES: "spades",
}

var strength_names = {
	11: "jack",
	12: "queen",
	13: "king",
	14: "ace",
}

func init(strength, suit):
	var image_full_path = par_to_resource(strength, suit)
	if images_folder_path:
		$BG.texture = load(image_full_path)
	else:
		print("Something wrong with %s and %s" % [strength, suit])

func par_to_resource(strength, suit):
	var converted_strength = strength
	var converted_suit
	
	if not strength in range(2, 15):
		return ""
	elif strength in strength_names:
		converted_strength = strength_names[strength]
		
	if not suit in suit_names:
		return ""
	else:
		converted_suit = suit_names[suit]
	
	var image_full_path = images_folder_path + "%s_of_%s.png" % [converted_strength, converted_suit]
	
	if File.new().file_exists(image_full_path):
		return image_full_path
	else:
		print("Image was not found: ", image_full_path)
		return ""

