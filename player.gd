extends Area2D

const TILE_SIZE = 64
const WALK_DURATION = 0.2
const PUSH_DURATION = 0.4

var inputs = {
	"player_right": Vector2.RIGHT,
	"player_left": Vector2.LEFT,
	"player_up": Vector2.UP,
	"player_down": Vector2.DOWN,
}
var animations = {
	"player_right": "walk_right",
	"player_left": "walk_left",
	"player_up": "walk_up",
	"player_down": "walk_down",
}
@onready var animated_sprite : = $AnimatedSprite2d
@onready var ray : = $RayCast2d

var tween: Tween


func _ready() -> void:
	$Camera2d.current = true


func _physics_process(_delta: float) -> void:
	if tween and tween.is_valid():
		return

	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			move(dir)


func move(dir) -> void:
	ray.target_position = inputs[dir] * TILE_SIZE
	ray.force_raycast_update()
	var c = ray.get_collider()
	if not c:
		walk(dir, WALK_DURATION)
	elif c.is_in_group("crates"):
		assert(c.has_method("push"))
		if c.push(inputs[dir] * TILE_SIZE, PUSH_DURATION):
			walk(dir, PUSH_DURATION)


func walk(dir, duration) -> void:
	animated_sprite.play(animations[dir])
	tween = create_tween()
	tween.tween_property(self, "position", inputs[dir] * TILE_SIZE, duration).as_relative()
	tween.tween_callback(animated_sprite.stop)
