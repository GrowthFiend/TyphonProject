tool

extends Control

export var rank : String setget set_rank, get_rank
export var suit : String setget set_suit, get_suit

# @todo Позже нужно брать это из настроек
const IMG_DIR = "res://Textures/Cards/FrenchSuited/"
const NAME_PATTERN = "$rank_of_$suit.png"

func set_id(r, s):
	rank = r
	suit = s
	update_view()

func id_to_resource(r, s):
	return NAME_PATTERN.replace("$rank", r).replace("$suit", s)

func update_view():
	if not rank or not suit:
		return
	
	var image_full_path = str(IMG_DIR + id_to_resource(rank, suit))

	if File.new().file_exists(image_full_path):
		$BG.texture = load(image_full_path)
	else:
		print_debug("Something wrong with `%s` or `%s`" % [rank, suit])

func set_rank(r):
	update_view()
	rank = str(r)
	
func get_rank():
	return rank
	
func set_suit(s):
	update_view()
	suit = s
	
func get_suit():
	return suit

