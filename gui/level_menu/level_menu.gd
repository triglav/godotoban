extends ScrollContainer

const GameScene = preload("res://game/game.tscn")
const LevelButton = preload("res://gui/level_menu/level_button.tscn")

@onready var container = $MarginContainer/HFlowContainer as HFlowContainer

var current_scene = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

	assert(UserData.last_level <= Constants.MAX_LEVEL)
	for i in range(Constants.MAX_LEVEL):
		var l = LevelButton.instantiate()
		l.level = i
		l.locked = i > UserData.last_level
		l.pressed.connect(_on_level_picked)
		container.add_child(l)
		if i == UserData.last_level:
			l.button.grab_focus()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		get_tree().change_scene_to_file("res://gui/main_menu.tscn")


func _on_level_picked(level) -> void:
	print_debug("level ", level)
	var s = GameScene.instantiate()
	s.level = level
	goto_scene(s)


func goto_scene(new_scene):
	call_deferred("_deferred_goto_scene", new_scene)


func _deferred_goto_scene(new_scene):
	current_scene.queue_free()
	current_scene = new_scene
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
