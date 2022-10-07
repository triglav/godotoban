extends Node

const Level = preload("res://level.tscn")
const Player = preload("res://player.tscn")
const Crate = preload("res://crate.tscn")

const AtlasBrickCoord = Vector2i(6, 6)
const AtlasFloorCoord = Vector2i(11, 6)
const AtlasGoalCoord = Vector2i(12, 1)


func build_level(file_path: String, number: int = 0) -> Level:
	var data = _load_level(file_path, number)
	var l = _build_tiles(data)
	return l


func _load_level(file_path: String, number: int) -> String:
	var f = FileAccess.open(file_path, FileAccess.READ)
	var chunks = f.get_as_text().split("---", false)
	assert(chunks.size() >= number)
	var c = chunks[number]
	print_debug(c)
	return c


func _build_tiles(data: String) -> Level:
	var rows = data.split("\n", false)
	var l = Level.instantiate() as Level
	# origin - starting player position - used as a starting coordinate to fill the level with floor tiles
	var o: Vector2i
	var y = 0
	for r in rows:
		if r.left(1) == ";":
			continue
		var x = 0
		for c in r:
			match c:
				";": # comments
					break
				"#": # wall
					l.set_cell(0, Vector2i(x, y), 1, AtlasBrickCoord)
				"@": # player
					_spawn(l, Player, x, y)
					o = Vector2i(x, y)
				"+": # player on goal square
					_spawn(l, Player, x, y)
					o = Vector2i(x, y)
					l.set_cell(1, Vector2i(x, y), 1, AtlasGoalCoord)
				"$": # crate
					_spawn(l, Crate, x, y)
				"*": # create on goal square
					_spawn(l, Crate, x, y)
					l.set_cell(1, Vector2i(x, y), 1, AtlasGoalCoord)
				".": # goal square
					l.set_cell(1, Vector2i(x, y), 1, AtlasGoalCoord)
				" ": # floor
					pass
				var ce:
					push_error("Unexpected character '", ce, "'")
			x += 1
		y += 1
	_fill_floor(l, o)
	return l


func _spawn(l:Node, o: PackedScene, x: int, y: int) -> void:
	var i = o.instantiate()
	i.position = Vector2(x*64+32, y*64+32)
	l.add_child(i)


func _fill_floor(l: Level, o: Vector2i) -> void:
	assert(o.x >= 0 and o.y >= 0)
	var todo = [o]
	while not todo.is_empty():
		var c = todo.pop_front() as Vector2i
		l.set_cell(0, c, 1, AtlasFloorCoord)
		_push_todo(l, Vector2i(c.x-1, c.y), todo)
		_push_todo(l, Vector2i(c.x+1, c.y), todo)
		_push_todo(l, Vector2i(c.x, c.y-1), todo)
		_push_todo(l, Vector2i(c.x, c.y+1), todo)


func _push_todo(l: Level, c: Vector2i, todo: Array) -> void:
	if l.get_cell_source_id(0, c) == -1:
		todo.push_back(c)
