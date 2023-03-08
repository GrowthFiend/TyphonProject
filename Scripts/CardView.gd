extends Control

# @todo Позже нужно брать это из настроек
const IMG_DIR = "res://Textures/Cards/FrenchSuited/"
const NAME_PATTERN = "$rank_of_$suit.png"

func init(rank, suit):
	var image_full_path = str(IMG_DIR + id_to_resource(rank, suit))

	if File.new().file_exists(image_full_path):
		$BG.texture = load(image_full_path)
	else:
		print_debug("Something wrong with `%s` or `%s`" % [rank, suit])

func id_to_resource(rank, suit):
	return NAME_PATTERN.replace("$rank", rank).replace("$suit", suit)
