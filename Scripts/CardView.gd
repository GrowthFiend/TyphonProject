@tool
extends Control

@export var rank : String : get = get_rank, set = set_rank
@export var suit : String : get = get_suit, set = set_suit
@export var style : String : get = get_style, set = set_style

var _cache = {}

# @todo Позже нужно брать это из настроек
const IMG_DIR = "res://Textures/Cards/"
const PARAMS = "params.ini"

func set_id(r, s, update : bool = true):
	rank = r
	suit = s
	if update: update_view()

func get_full_path():
	var style_dir = str(IMG_DIR, style, "/")
	if not DirAccess.dir_exists_absolute(style_dir):
		return ""
	
	var style_params = get_params(style)
	
	if style_params.is_empty() or not style_params.has("params"):
		print("no style ", style)
		return ""
	
	if style_params["params"].is_empty():
		#  or not style_params["params"].has("namepattern")
		print("Couldn't find namepattern for style `%s`" % style)
		return ""
		
	var namepattern = style_params["params"]["namepattern"]
	var mapped_rank = get_grandspring("ranks", rank, style_params)
	var mapped_suit = get_grandspring("suits", suit, style_params)
	
	return str(style_dir, namepattern.
		replace("$rank", mapped_rank).
		replace("$suit", mapped_suit))
	
func get_params(s):
	if s in _cache:
		return _cache[s]
		
	var mapper_path = str(str(IMG_DIR, s, "/"), PARAMS)
		
	var cf = ConfigFile.new()
	var err = cf.load(mapper_path)
	# 43 - ERR_PARSE_ERROR
	if err != OK:
		print("ConfigFile.load erro %s" % err)
		return {}
	
	var config = {}
	for section in cf.get_sections():
		config[section] = {}
		for key in cf.get_section_keys(section):
			config[section][key] = str(cf.get_value(section, key))

	_cache[s] = config
	if config.is_empty():
		print_debug("Styleparams epmty `%s`" % mapper_path)
	return config
	
func get_grandspring(child, grandspring, ar):
	if ar.has(child) and ar[child].has(grandspring):
		return ar[child][grandspring]
	else:
		return grandspring

func update_view():
	if rank == "" or suit == "":
		return
	
	var image_full_path = get_full_path()
	if image_full_path and UsefullFunctions.file_exists(image_full_path):
		$BG.texture = load(image_full_path)
		$Text.hide()
		$BG.show()
	else:
		$Text.text = "%s of %s \n (%s)" % [rank, suit, style]
		$Text.show()
		$BG.hide()

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

func set_style(s):
	style = s
	update_view()

func get_style():
	return style
