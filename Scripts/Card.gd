@tool

class_name Card
extends Area2D

@export var rank : String : get = get_rank, set = set_rank
@export var suit : String : get = get_suit, set = set_suit
@export var style : String : get = get_style, set = set_style
@export var is_open : bool = true

func _ready():
	update_view()
	
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

func flip():
	is_open = not is_open
