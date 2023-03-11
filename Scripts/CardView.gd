@tool
extends Control

@export var rank : String : get = get_rank, set = set_rank
@export var suit : String : get = get_suit, set = set_suit
@export var style : String : get = get_style, set = set_style

var is_open = true

# @todo Позже нужно брать это из настроек
const IMG_DIR = "res://Textures/Cards/"
const PARAMS = "params.ini"

func set_id(new_rank : String, new_suit : String):
	rank = new_rank
	suit = new_suit

func get_full_path():
	if style == "":
		return ""
		
	var style_dir = str(IMG_DIR, style, "/")
	if not DirAccess.dir_exists_absolute(style_dir):
		return ""
	
	var cache_key = "CardView_" + style + "_" + rank + "_" + suit
	if not Engine.is_editor_hint() and Cache.has(cache_key):
		return Cache.retrieve(cache_key)
	
	var style_params = get_params(style)
	if style_params.is_empty() or not style_params.has("params"):
		print("no style ", style)
		return ""
	
	if style_params["params"].is_empty():
		print("Couldn't find namepattern for style `%s`" % style)
		return ""
		
	var namepattern = style_params["params"]["namepattern"]
	var mapped_rank = get_grandspring("ranks", rank, style_params)
	var mapped_suit = get_grandspring("suits", suit, style_params)
	var full_path = str(style_dir, namepattern.
		replace("$rank", mapped_rank).
		replace("$suit", mapped_suit))
	
	if not Engine.is_editor_hint():
		Cache.add(cache_key, full_path)
	return full_path
	
func get_params(s):
	var cache_key = "CardView_" + s
	# кеш работает только в игре. как и все автолоады
	if not Engine.is_editor_hint() and Cache.has(cache_key):
		return Cache.retrieve(cache_key)
		
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

	if not Engine.is_editor_hint():
		Cache.add(cache_key, config)
		
	if config.is_empty():
		print_debug("Styleparams epmty `%s`" % mapper_path)
	return config
	
func get_grandspring(child, grandspring, ar):
	if ar.has(child) and ar[child].has(grandspring):
		return ar[child][grandspring]
	else:
		return grandspring

func update_view():
	var image_full_path = get_full_path()
	if image_full_path and FileAccess.file_exists(image_full_path):
		$Face/Face_BG.texture = load(image_full_path)
		$Face/Text.hide()
		$Face/Face_BG.show()
	else:
		$Face/Text.text = "%s of %s \n (%s)" % [rank, suit, style]
		$Face/Text.show()
		$Face/Face_BG.hide()

func set_rank(new_rank : String):
	if rank != new_rank:
		rank = new_rank
	
func get_rank():
	return rank
	
func set_suit(new_suit : String):
	if suit != new_suit:
		suit = new_suit
	
func get_suit():
	return suit

func set_style(new_style : String):
	if style != new_style:
		style = new_style

func get_style():
	return style
