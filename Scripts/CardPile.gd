extends Node

@export var card_scene: PackedScene
var Card = preload("res://Scripts/Card.gd")

var _cards = []

func populate(card_ids):
	for id in card_ids:
		var card = card_scene.instantiate()
		card.set_id(id)
		card = before_add_card(card)
		card = add_card(card)
		after_card_add(card)
	return self
	

func clear():
	for card in _cards:
		card.queue_free()

	_cards.clear()
	return self

func get_all_card_ids():
	var ids = []
	for card in _cards:
		ids.append(card.get_id())
	return ids

func before_add_card(card):
	return card
	
func add_card(card): # Нужно как-то указать, что принимать только класс Card
	_cards.append(card)
	add_child(card)
	return card
	
func after_card_add(card):
	return card

func shuffle():
	_cards.shuffle()
	return self
	
func size():
	return _cards.size()
