extends Node2D

func _ready():
	$Deck__main.draw_in_lines()

func _on__TempTimer_timeout():
	$Deck__main.shuffle().draw_in_lines()
