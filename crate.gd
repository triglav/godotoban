extends Area2D

@onready var sprite : = $Sprite2d
@onready var ray : = $RayCast2d

signal crate_moved(crate, position)

var _on_goal = false
var on_goal: bool:
	get:
		return _on_goal
	set(value):
		_on_goal = value
		_update_tint()

func push(delta, duration) -> bool:
	ray.target_position = delta
	ray.force_raycast_update()
	if ray.is_colliding():
		return false
	var tween = create_tween()
	tween.tween_property(self, "position", delta, duration).as_relative()
	tween.tween_callback(emit_signal.bind("crate_moved", self, position + delta))
	return true


func _update_tint() -> void:
	if _on_goal:
		sprite.modulate = Color(0.5, 0.5, 0.5)
	else:
		sprite.modulate = Color(1.0, 1.0, 1.0)
