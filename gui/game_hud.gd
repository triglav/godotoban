extends CanvasLayer

@onready var move_count_label = $MarginContainer/MoveCountLabel


func update_move_count(value: int) -> void:
	move_count_label.text = "Moves: " + str(value)


func reset() -> void:
	update_move_count(0)
