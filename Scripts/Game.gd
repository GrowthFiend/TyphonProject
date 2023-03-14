extends Node2D

@export var player_scene: PackedScene

var is_game_over = false
var is_paused = false
const PLAYERS_COUNT = 5 #будет выбор в меню
var players_in_game = PLAYERS_COUNT
const TABLE_CENTER = Vector2(960, 540)
const TABLE_RADIUS = 400
var m_turn = 0
var players = []

func _ready():
	randomize()
	get_node("Table_with_Stake/Deck").set_appearance("Roughly")
	var i = 0
	var current_player_position = Vector2(0, TABLE_RADIUS)
	const alpha_for_player = 2*PI/PLAYERS_COUNT
	while i < PLAYERS_COUNT:
		var current_player = "Player%s" % i
		var player = player_scene.instantiate()
		players.push_back(player)
		add_child(player)
		print(player.name)
		player.name=current_player
		get_node(current_player).set_character("Bot")
		get_node(current_player).get_node("Hand").set_appearance("Fan")
		get_node(current_player).position = TABLE_CENTER + current_player_position
		get_node(current_player).rotation = current_player_position.angle()-PI/2
		current_player_position=current_player_position.rotated(alpha_for_player)
		i += 1
	get_node("Player0").set_character("User")
	get_node("Table_start/Deck").init({
		"name": "full",
		"style": ["FrenchSuited", "PixelFantasy", "zxyonitch"].pick_random(),
	}).shuffle()
	await hand_out_cards()
	is_game_over = false
	play()

func _process(_delta):
	if is_paused and not is_game_over: play()

func play():
	is_paused = false
	while not is_game_over and not get_tree().paused:
		var current_player = "Player%s" % m_turn
		if not get_node(current_player).is_retired:
			get_node(current_player).get_node("Turn").disabled = false
			if get_node(current_player).get_character() == "User":
				await get_node(current_player).get_node("Turn").pressed
			await turn_card(get_node(current_player))
			await get_tree().create_timer(1.5/GLOBAL.GAME_SPEED).timeout
		m_turn = (m_turn+1)%PLAYERS_COUNT	
	is_paused = true
	
func hand_out_cards():
	var i = get_node("Table_start/Deck").size()
	while i > 0:
		var card = get_node("Table_start/Deck").pop_back()
		var turn = i%PLAYERS_COUNT
		var current_player = "Player%s" % turn
		get_node(current_player).get_node("Hand").push_back(card)
		i -= 1
		await get_tree().create_timer(0.05/GLOBAL.GAME_SPEED).timeout
	return
	
func turn_card(cur_player):
	var card = cur_player.get_node("Hand").pop_back()
	card.flip()
	get_node("Table_with_Stake/Deck").push_back(card)
	cur_player.get_node("Turn").disabled = true
	if not is_stake_ok() : await take_stake(cur_player)
	else : await check_win(cur_player)
	return

func is_stake_ok():
	var stake = get_node("Table_with_Stake/Deck")
	if stake.size() > 1:
		return calculate_sthength(stake._cards[stake.size()-1]) >= calculate_sthength(stake._cards[stake.size() - 2])
	else : return true
	
func calculate_sthength(card):
	match card.rank:
		"jack": return 11
		"queen": return 12
		"king": return 13
		"ace": return 14
		"joker": return 15
		_: return int(card.rank)
	
func take_stake(cur_player):
	await get_tree().create_timer(1.5/GLOBAL.GAME_SPEED).timeout
	var stake_size = get_node("Table_with_Stake/Deck").size()
	while stake_size != 0:
		var card = get_node("Table_with_Stake/Deck").pop_front()
		card.flip()
		cur_player.get_node("Hand").push_front(card)
		stake_size -= 1
	return

func check_win(cur_player):
	if cur_player.get_node("Hand").size() == 0:
		await get_tree().create_timer(2/GLOBAL.GAME_SPEED).timeout
		cur_player.is_retired = true
		players_in_game -= 1
		if players_in_game == 1: 
			get_tree().paused = true
			$WinLabel.text = "We have a looser!!!"
			$WinLabel.visible = true
			is_game_over=true
	return



