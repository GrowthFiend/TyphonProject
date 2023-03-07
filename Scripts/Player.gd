extends Node2D

func _ready():
	$Hand.init()



func _on_Turn_pressed():
	var card = $Hand.pop_back()
	card.flip()
	get_parent().get_node("Table/Stake").push_back(card)
	get_parent().get_node("Table/Stake").add_child(card)
