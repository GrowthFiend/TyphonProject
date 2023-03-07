extends Node2D
export var pl_id = 0

func _ready():
	$Hand.init()



func _on_Turn_pressed():
	var card = $Hand.pop_back()
	card.flip()
	get_parent().get_node("Table/Stake").push_back(card)
	get_parent().get_node("Table/Stake").add_child(card)
	$Turn.visible = false
	get_parent().change_turn()
