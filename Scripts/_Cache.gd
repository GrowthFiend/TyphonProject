extends Node

var _cache = {}
var _stats = {
	"has_calls": 0,
	"has_true": 0,
	"has_false": 0,
	
	"retrieve_calls": 0,
	"add_calls": 0,
	"keys_count": 0
}

func has(key):
	_stats.has_calls += 1
	if _cache.has(key):
		_stats.has_true += 1
	else:
		_stats.has_false += 1
	return _cache.has(key)

func retrieve(key):
	_stats.retrieve_calls += 1
	return _cache[key]

func add(key, value):
	_stats.add_calls += 1
	_cache[key] = value
	
func get_stats():
	_stats.keys_count = _cache.size()
	return _stats

