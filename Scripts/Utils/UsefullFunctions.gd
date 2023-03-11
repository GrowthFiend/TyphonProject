class_name UsefullFunctions

extends Node

static func file_exists(path : String):
	if ResourceLoader.exists(path):
		return true
	if path.find('://') != -1:
		var split = path.split('://')
		var dir = DirAccess.open(split[0]+'://')
		return dir.file_exists(split[1])
	return false
