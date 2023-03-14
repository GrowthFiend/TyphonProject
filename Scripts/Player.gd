extends Node2D
@export var pl_id = 0
@export_enum("User", "Bot") var character : get = get_character, set = set_character

func _ready():
	pass

func _on_Turn_pressed():
	turn_card()
	
func turn_card():
	var card = $Hand.pop_back()
	card.flip()
	get_parent().get_node("Table_with_Stake/Deck").push_back(card)
	$Turn.disabled = true
	if not is_stake_ok():
		await get_tree().create_timer(1/GLOBAL.GAME_SPEED).timeout
		take_stake()
	else : check_win()
	await get_tree().create_timer(1/GLOBAL.GAME_SPEED).timeout
	get_parent().next_turn()
	return

func is_stake_ok():
	return get_parent().get_node("Table_with_Stake/Deck").is_stake_ok()

func take_stake():
	var stake_size = get_parent().get_node("Table_with_Stake/Deck").size()
	while stake_size != 0:
		var card = get_parent().get_node("Table_with_Stake/Deck").pop_front()
		card.flip()
		$Hand.push_front(card)
		stake_size -= 1
		await get_tree().create_timer(0.2/GLOBAL.GAME_SPEED).timeout
	return

func check_win():
	if $Hand.size() == 0:
		get_tree().paused = true
		get_parent().get_node("WinLabel").text = "Player %s Win!!!" % pl_id
		get_parent().get_node("WinLabel").visible = true
	return

func update_hud():
	match character:
		"User":
			$Turn.visible = true
		"Bot":
			$Turn.visible = false

func set_character(new_character : String):
	if character == new_character:
		return
	character = new_character
	update_hud()

func get_character():
	return character
