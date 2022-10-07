extends Node

var file = "user://user.dat"
var last_level = 0


func _ready() -> void:
	load_data()


func update_last_level(level: int) -> void:
	last_level = level
	save_data()


func save_data() -> void:
	print_debug("save_data")
	var f = FileAccess.open(file, FileAccess.WRITE)
	f.store_32(last_level)


func load_data() -> void:
	print_debug("load_data")
	var f = FileAccess.open(file, FileAccess.READ)
	if not f:
		print_debug("nothing")
		return
	last_level = f.get_32()
	print_debug("last_level: ", last_level)
