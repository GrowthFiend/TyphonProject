@tool

class_name Card
extends Area2D

@export var rank : String : get = get_rank, set = set_rank
@export var suit : String : get = get_suit, set = set_suit
@export var style : String : get = get_style, set = set_style
@export var is_open : bool = true : get = get_is_open, set = set_is_open

var target_position = Vector2(0, 0)
var target_rotation = 0
var need_update_target = true
var speed = 3

func _ready():
	update_view()
	
func _process(delta):
	if position != target_position:
		position = lerp(position, target_position, speed*delta)
	if rotation != target_rotation:
		rotation = lerp(rotation, target_rotation, speed*delta)
	
func update_view():
	if has_node("CardView"):
		$CardView.set_id(rank, suit, is_open)
		$CardView.style = style
		$CardView.update_view()

func set_id(id):
	rank = str(id[0])
	suit = str(id[1])
	
func get_id():
	return [rank, suit]

func set_rank(r):
	rank = str(r)
	
func get_rank():
	return rank
	
func set_suit(s):
	suit = str(s)
	
func get_suit():
	return suit

func set_style(s):
	style = s

func get_style():
	return style
	
func set_target_position(new_pos):
	target_position = new_pos

func get_target_position():
	return target_position

func flip():
	is_open = not is_open

func get_is_open():
	return is_open
	
func set_is_open(new_is_open : bool):
	is_open = new_is_open
	$CardView.is_open = is_open
#	
