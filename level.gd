extends TileMap
class_name Level

var crates

signal level_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# This may contain crates from other levels
	var all_crates = get_tree().get_nodes_in_group("crates")
	print_debug("ALL_CRATES ", all_crates.size())
	crates = []
	for c in all_crates:
		if is_ancestor_of(c):
			crates.push_back(c)
			c.crate_moved.connect(_on_crate_moved)
			_on_crate_moved(c, c.position)
	print_debug("CRATES ", crates.size())


func _on_crate_moved(crate, crate_position):
	var p = local_to_map(crate_position)
	crate.on_goal = _is_crate_on_goal_tile(p)
	if crate.on_goal:
		if _are_all_crates_on_goal_tiles():
			print_debug("Level complete")
			level_complete.emit()


func _is_crate_on_goal_tile(crate_position) -> bool:
	var id = get_cell_source_id(1, crate_position)
	if id != -1:
		var c = get_cell_tile_data(1, crate_position)
		if c:
			return c.get_custom_data("goal")
	return false


func _are_all_crates_on_goal_tiles() -> bool:
	for c in crates:
		if not c.on_goal:
			return false
	return true
