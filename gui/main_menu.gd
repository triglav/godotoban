extends Control

const game_scene = preload("res://game.tscn")


func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		$VBoxContainer/QuitButton.grab_focus()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
