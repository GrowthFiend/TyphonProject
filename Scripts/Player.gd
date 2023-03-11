extends Node2D
@export var pl_id = 0

func _ready():
#	$Hand.init()
	pass

func _process(delta):
	if Input.is_action_just_pressed("turn_next_card"):
		turn_card()

func _on_Turn_pressed():
	turn_card()
	
func turn_card():
	var card = $Hand.pop_back()
	card.flip()
	get_parent().get_node("Table/Stake").push_back(card)
	get_parent().get_node("Table/Stake").add_child(card)
	$Turn.visible = false
	if not is_stake_ok():
		take_stake()
	else : check_win()
	get_parent().change_turn()

func is_stake_ok():
	return get_parent().get_node("Table/Stake").is_stake_ok()

func take_stake():
	var stake_size = get_parent().get_node("Table/Stake").size()
	while stake_size != 0:
		var card = get_parent().get_node("Table/Stake").pop_front()
		card.flip()
		$Hand.push_front(card)
		$Hand.add_child(card)
		stake_size -= 1

func check_win():
	if $Hand.size() == 0:
		get_tree().paused = true
		get_parent().get_node("WinLabel").text = "Player %s Win!!!" % pl_id
		get_parent().get_node("WinLabel").visible = true
