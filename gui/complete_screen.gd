extends Control


func _unhandled_input(_event: InputEvent) -> void:
	get_tree().change_scene_to_file("res://gui/main_menu.tscn")
