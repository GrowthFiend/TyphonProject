@tool
extends Control

# @todo Позже нужно брать это из настроек
const IMG_DIR = "res://Textures/Cards/"
const PARAMS = "params.ini"

@export var rank : String : get = get_rank, set = set_rank
@export var suit : String : get = get_suit, set = set_suit
@export var style : String : get = get_style, set = set_style
@export var is_open : bool = true : get = get_is_open, set = set_is_open

func _ready():
	sync_open_status()
	
# Hack нужно что-то другое придумать для проверки
func is_ready():
	return has_node("Face")

func set_id(new_rank : String, new_suit : String, new_is_open):
	rank = new_rank
	suit = new_suit
	is_open = new_is_open

func get_full_path():
	var full_path = {
		"front": "",
		"back": "",
	}
	
	if style == "":
		return full_path
		
	var style_dir = str(IMG_DIR, style, "/")
	if not DirAccess.dir_exists_absolute(style_dir):
		return full_path
	
	var cache_key = "CardView_" + style + "_" + rank + "_" + suit
	if not Engine.is_editor_hint() and Cache.has(cache_key):
		return Cache.retrieve(cache_key)
	
	var style_params = get_params(style)
	if style_params.is_empty() or not style_params.has("params"):
		print("no style ", style)
		return full_path
	
	if style_params["params"].is_empty():
		print("Couldn't find params for style `%s`" % style)
		return full_path
		
	var front_full_path = ""
	if style_params["params"].has("namepattern"):
		var namepattern = style_params["params"]["namepattern"]
		var mapped_rank = get_grandspring("ranks", rank, style_params)
		var mapped_suit = get_grandspring("suits", suit, style_params)
		front_full_path = str(style_dir, namepattern.
				replace("$rank", mapped_rank).
				replace("$suit", mapped_suit))
				
	
	full_path = {
		"front": front_full_path,
		"back": str(style_dir, style_params["params"]["back"] if style_params["params"].has("back") else "")
	}
	
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
	if image_full_path["front"] != "" and FileAccess.file_exists(image_full_path["front"]):
		$Face/BG.texture = load(image_full_path["front"])
		$Face/BG.show()
		$Face/Fallback.hide()
	else:
		$Face/Fallback.text = "%s of %s \n (%s)" % [rank, suit, style]
		$Face/Fallback.show()
		$Face/BG.hide()
		
	if image_full_path["back"] != "" and FileAccess.file_exists(image_full_path["back"]):
		$Back/BG.texture = load(image_full_path["back"])
		$Back/BG.show()
		$Back/Fallback.hide()
	else:
		$Back/Fallback.text = "Back \n (%s)" % [style]
		$Back/Fallback.show()
		$Back/BG.hide()


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

func get_is_open():
	return is_open
	
func set_is_open(new_is_open : bool):
	if is_open == new_is_open:
		return
	is_open = new_is_open
	sync_open_status()
		
func sync_open_status():
	if not is_ready(): return
	
	if is_open:
		$Face.show()
		$Back.hide()
	else: 
		$Back.show()
		$Face.hide()
