extends ScrollContainer

const LevelButton = preload("res://gui/level_menu/level_button.tscn")

@export_range(1, 100, 1) var levels: int = 10
@export_range(1, 100, 1) var unlocked: int = 2

@onready var container = $MarginContainer/HFlowContainer as HFlowContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(levels >= unlocked)
	for i in range(levels):
		var l = LevelButton.instantiate()
		l.level = i + 1
		l.locked = l.level > unlocked
		container.add_child(l)
