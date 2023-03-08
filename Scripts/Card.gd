extends Area2D

var _rank
var _suit

func _ready():
	$CardView.init(_rank, _suit)

func init(id):
	_rank = id[0]
	_suit = id[1]
	
func get_id():
	return [_rank, _suit]
