extends CanvasLayer

signal resume
signal restart
signal quit

func _ready() -> void:
	$VBoxContainer/ResumeButton.grab_focus()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		resume.emit()


func _on_resume_button_pressed() -> void:
	resume.emit()


func _on_restart_button_pressed() -> void:
	restart.emit()


func _on_quit_button_pressed() -> void:
	quit.emit()


func _on_pause_menu_visibility_changed() -> void:
	if visible:
		$VBoxContainer/ResumeButton.grab_focus()
