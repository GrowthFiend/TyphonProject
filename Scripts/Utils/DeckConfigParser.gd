class_name DeckConfigParser

extends Node

# Эта регулярка ищет одно из двух
# A) rank * suit (знак умножения между словами),
# Б) deck (без знака умножить)
# И определят знак перед этой конструкцией, чтобы дальше "сложить" или "вычесть"
const DECK_FINDER = "(^|(?<sign>\\+|\\-))\\s*(:?(?<rank>\\w+)\\s*\\*\\s*(?<suit>\\w+)|(?<deck>\\w*))"

var _config = {
	"ranks": {},
	"suits": {},
	"decks": {},
}

func init(config_path):
	if config_path == "":
		print("Empty config path")
		return
	
	if not UsefullFunctions.file_exists(config_path):
		print("Could't find a config `%s`" % config_path)
		return
	
	var cf = ConfigFile.new()
	var err = cf.load(config_path)
	# 43 - ERR_PARSE_ERROR
	if err != OK:
		print("ConfigFile.load erro %s" % err)
		return

	for section in _config:
		if not cf.has_section(section): continue
		for key in cf.get_section_keys(section):
			var str_value = str(cf.get_value(section, key))
			if section == "decks":
				_config[section][key] = str_value
			else:
				var ar_value = []
				# Вот эта вся лабуда нужна, чтобы из 2..10 сделать массив 
				# [2, 3, 4, 5, 6, 7, 8, 9, 10]
				# Отрицательные тоже прокатаят, например -3..1 станет
				# [-3, -2, -1, 0, 1]
				# Мб перенести это куда-нибудь
				var re = RegEx.new()
				re.compile("(\\-?\\d+)\\.\\.(\\d+)")
				for v in str_value.split(" "):
					var m = re.search(v)
					if m:
						for i in range(int(m.get_string(1)), int(m.get_string(2)) + 1):
							ar_value.append(i)
					else:
						ar_value.append(v)
					
				_config[section][key] = ar_value

func get_ids(deck_name, i : int = 0):
	if i > 10:
		print("Infinitive loop yoba")
		return []
		
		
	var cache_key = "DeckConfigParser_" + deck_name
	# кеш работает только в игре. как и все автолоады
	if not Engine.is_editor_hint() and Cache.has(cache_key):
		return Cache.retrieve(cache_key)
	
	if not _config["decks"].has(deck_name):
		return []
		
	var deck_params = _config["decks"][deck_name]
	
	var re_deck = RegEx.new()
	re_deck.compile(DECK_FINDER)
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
			
	if not Engine.is_editor_hint():
		Cache.add(cache_key, card_ids)
	
	return card_ids

# Вообще эти две функции (особенно первая элитная) не особенно нужны, 
# а особенно тут, но сделал так для наглядности и единобразия
# В принципе, весь их код можно скопировать выше, а функии удалить
func array_adding(ar1, ar2):
	return ar1 + ar2
	
func array_subtraction(ar1, ar2):
	for el in ar2:
		ar1.erase(el)
		
	return ar1
