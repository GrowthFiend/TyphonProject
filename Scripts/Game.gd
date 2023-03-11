extends Node2D

var _change_deck : bool = true
var _decks_pool = ["52", "small", "reds", "spades", "no_spades"]
var _styles_pool = ["zxyonitch", "PixelFantasy", "FrenchSuited"]

func _ready():
	$Deck__main.init({
		"name": get_random(_decks_pool),
		"style": get_random(_styles_pool),
	}).draw_in_lines()

func _on__TempTimer_timeout():
	if _change_deck:
		$Deck__main.deck_name = get_random(_decks_pool, $Deck__main.deck_name)
	else: 
		$Deck__main.style = get_random(_styles_pool, $Deck__main.style)
	_change_deck = not _change_deck

func get_random(pool : Array, exclude = ""):
	var temp_pool = pool.duplicate()
	if exclude != "":
		temp_pool.erase(exclude)
	return temp_pool.pick_random()
	
