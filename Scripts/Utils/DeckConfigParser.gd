extends Node

var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
var _cache = {}
var _config

func init(config_path):
	var f = File.new()
	f.open(config_path, File.READ)
	var c = f.get_as_text()
	if validate(c):
		_config = yaml.parse(c).result
	else:
		# что-то не так с колодой, нужно как-то сообщить об этом
		pass
	f.close()
	
# пока проверка всегда проходит
func validate(config):
	return true

func get_ids(deck_name, i : int = 0):
	if i > 10:
		print("Infinitive loop yoba")
		return []
		
	if deck_name in _cache:
		#print("`%s` found in cache" % deck_name)
		return _cache[deck_name]
		
	var deck_params = _config["deck"][deck_name]
	
	var re_deck = RegEx.new()
	re_deck.compile("(^|(?<sign>\\+|\\-))\\s*(:?(?<rank>\\w+)\\s*\\*\\s*(?<suit>\\w+)|(?<deck>\\w*))")
	var card_ids = []
	for m in re_deck.search_all(deck_params):
		var working_ar = []
		var deck = m.get_string("deck")
		if deck:
			working_ar = get_ids(deck, i + 1)
		else:
			for r in _config["ranks"][m.get_string("rank")]:
				for s in _config["suits"][m.get_string("suit")]:
					working_ar.append([r, s])
		
		if m.get_string("sign") == "-":
			card_ids = array_subtraction(card_ids, working_ar)
		else:
			card_ids = array_adding(card_ids, working_ar)
			
	_cache[deck_name] = card_ids
	return card_ids

func array_adding(ar1, ar2):
	return ar1 + ar2
	
func array_subtraction(ar1, ar2):
	for el in ar2:
		ar1.erase(el)
		
	return ar1
