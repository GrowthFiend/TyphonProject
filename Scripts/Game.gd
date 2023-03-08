extends Node2D

func _ready():
	$Deck__main.draw()

func _on__TempTimer_timeout():
	$Deck__main.shuffle().draw()
