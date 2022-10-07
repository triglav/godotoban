extends Control

@export var level: int = 0
@export_range(0, 3, 1) var stars: int = 0
@export var locked: bool = false

signal pressed(level)

@onready var button = $VBoxContainer/Button as Button
@onready var star1 = $VBoxContainer/HBoxContainer/Star1 as TextureRect
@onready var star2 = $VBoxContainer/HBoxContainer/Star2 as TextureRect
@onready var star3 = $VBoxContainer/HBoxContainer/Star3 as TextureRect
@onready var lock_overlay = $LockOverlay as ColorRect


func _ready() -> void:
	_update_level()
	_update_stars()
	_update_locked()


func _update_level() -> void:
	button.text = str(level)


func _update_stars() -> void:
	_update_star(star1, stars > 0)
	_update_star(star2, stars > 1)
	_update_star(star3, stars > 2)


func _update_star(star: TextureRect, lit: bool) -> void:
	if lit:
		star.modulate = "bb9500"
	else:
		star.modulate = "282828"


func _update_locked() -> void:
	lock_overlay.visible = locked
	button.focus_mode = Control.FOCUS_NONE if locked else Control.FOCUS_ALL


func _on_button_pressed() -> void:
	pressed.emit(level)
