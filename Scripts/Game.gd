extends Node2D

@export var player_scene: PackedScene

const PLAYERS_COUNT = 5 #будет выбор в меню
const TABLE_CENTER = Vector2(960, 540)
const TABLE_RADIUS = 400
var m_turn = 0

func _ready():
	randomize()
	get_node("Table_with_Stake/Deck").set_appearance("Roughly")
	var i = 0
	var current_player_position = Vector2(0, TABLE_RADIUS)
	const alpha_for_player = 2*PI/PLAYERS_COUNT
	while i < PLAYERS_COUNT:
		var current_player = "Player%s" % i
		var player = player_scene.instantiate()
		add_child(player)
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
	play()

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

func play():
	var current_player = "Player%s" % m_turn
	get_node(current_player).get_node("Turn").disabled = false
	if get_node(current_player).get_character() == "Bot":
		await get_tree().create_timer(0.5/GLOBAL.GAME_SPEED).timeout
		await get_node(current_player).turn_card()
	return

func next_turn():
	m_turn = (m_turn+1)%PLAYERS_COUNT
	play()
	return
