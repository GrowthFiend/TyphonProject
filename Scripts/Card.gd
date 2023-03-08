tool

extends Area2D

export var rank : String setget set_rank, get_rank
export var suit : String setget set_suit, get_suit
export var style : String setget set_style, get_style

func _ready():
	update_view()
	
func update_view():
	if not rank or not suit:
		return

	if has_node("CardView"):
		$CardView.set_id(rank, suit, false)
		$CardView.style = style

func set_id(id):
	rank = str(id[0])
	suit = str(id[1])
	update_view()
	
func get_id():
	return [rank, suit]

func set_rank(r):
	update_view()
	rank = str(r)
	
func get_rank():
	return rank
	
func set_suit(s):
	update_view()
	suit = str(s)
	
func get_suit():
	return suit

func set_style(s):
	style = s
	update_view()

func get_style():
	return style

