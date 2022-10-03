extends Node2D

@export_dir var levels_dir = "res://levels"
var levels: PackedStringArray
@export var current_level_idx = 0
var current_level = null


func _ready() -> void:
	levels = _discover_levels()
	_load_level(current_level_idx)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_menu") or event.is_action_released("ui_cancel"):
		get_tree().get_root().set_input_as_handled()
		_pause()


func _pause() -> void:
	get_tree().paused = true
	$PauseMenu.show()


func _resume() -> void:
	$PauseMenu.hide()
	get_tree().paused = false


func _load_level(idx):
	var previous_level = current_level
	if previous_level:
		previous_level.queue_free()
	current_level = load(levels[idx]).instantiate()
	add_child(current_level)
	current_level.level_complete.connect(_on_level_complete)


func _on_level_complete():
	current_level_idx += 1
	if current_level_idx >= levels.size():
		get_tree().change_scene_to_file("res://gui/complete_screen.tscn")
		return
	_load_level(current_level_idx)


func _discover_levels() -> PackedStringArray:
	assert(levels_dir)
	var files = DirAccess.get_files_at(levels_dir)
	for i in range(0, files.size()):
		files[i] = levels_dir + "/" + files[i]
	print_debug(files)
	return files


func _on_pause_menu_resume() -> void:
	_resume()


func _on_pause_menu_restart() -> void:
	_resume()
	_load_level(current_level_idx)


func _on_pause_menu_quit() -> void:
	_resume()
	get_tree().change_scene_to_file("res://gui/main_menu.tscn")
