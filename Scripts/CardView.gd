@tool
extends Control

var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
@export var rank : String : get = get_rank, set = set_rank
@export var suit : String : get = get_suit, set = set_suit
@export var style : String : get = get_style, set = set_style

var _cache = {}

# @todo Позже нужно брать это из настроек
const IMG_DIR = "res://Textures/Cards/"
const PARAMS = "params.yalm"

func set_id(r, s, update:bool = true):
	rank = r
	suit = s
	if update: update_view()

func get_full_path():
	var style_dir = str(IMG_DIR, style, "/")
	var style_params = {}
	if not style in _cache:
		var f = File.new()
		var mapper_path = str(style_dir, PARAMS)
		if File.new().file_exists(mapper_path):
			f.open(mapper_path, File.READ)
			style_params = yaml.parse(f.get_as_text()).result
			f.close()
		_cache[style] = style_params
	else:
		style_params = _cache[style]

	return str(style_dir, style_params["pattern"].replace(
			"$rank", get_grandspring("ranks", rank, style_params)
		).replace(
			"$suit", get_grandspring("suits", suit, style_params)
		))
	
func get_grandspring(child, grandspring, ar):
	if ar.has(child) and ar[child].has(grandspring):
		return ar[child][grandspring]
	else:
		return grandspring

func update_view():
	if not rank or not suit:
		return
	
	var image_full_path = get_full_path()
	if File.new().file_exists(image_full_path):
		$BG.texture = load(image_full_path)
	else:
		print_debug("Something wrong with `%s` [`%s` and `%s`]" % [image_full_path, rank, suit])

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
