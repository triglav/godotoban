extends Node2D

var current_level_idx: int
var current_level = null
@onready var game_hud = $GameHud

@onready var builder = load("res://game/level_builder.gd").new()

func _ready() -> void:
	current_level_idx = UserData.last_level
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
	current_level = builder.build_level(Constants.Levels, idx)
	add_child(current_level)
	current_level.level_complete.connect(_on_level_complete)
	current_level.move_count_change.connect(game_hud.update_move_count)
	game_hud.reset()


func _on_level_complete():
	current_level_idx += 1
	UserData.update_last_level(current_level_idx)
	if current_level_idx >= Constants.MAX_LEVEL:
		get_tree().change_scene_to_file("res://gui/complete_screen.tscn")
		return
	_load_level(current_level_idx)


func _on_pause_menu_resume() -> void:
	_resume()


func _on_pause_menu_restart() -> void:
	_resume()
	_load_level(current_level_idx)


func _on_pause_menu_quit() -> void:
	_resume()
	get_tree().change_scene_to_file("res://gui/main_menu.tscn")
