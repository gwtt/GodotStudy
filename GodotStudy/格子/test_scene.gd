extends Node2D

@export var cell_size      : int   = 64
@export var point_radius   : float = 6.0
@export var point_color    : Color = Color.BLACK
@export var selected_color : Color = Color.RED
@export var line_color     : Color = Color.YELLOW
@export var line_width     : float = 3.0
@export var path_color     : Color = Color.CYAN
@export var path_width     : float = 5.0


var points : Array[Vector2]    = []
var lines  : Array[Dictionary] = []

var selected_index : int = -1             
var path_start : int  = -1                 
var path_end   : int  = -1                 
var path       : Array[int] = []           

func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:  _handle_left_click(event.position)
			MOUSE_BUTTON_RIGHT: _handle_right_click(event.position)

func _handle_left_click(mouse_pos: Vector2) -> void:
	var snap := _snap_to_grid(mouse_pos)
	var idx  := _find_point_at(snap)

	if idx == -1:
		points.append(snap)
		var last := selected_index
		selected_index = points.size() - 1
		if last != -1 and last != selected_index and not _line_exists(last, selected_index):
			lines.append({ "a": last, "b": selected_index })
	else:
		if selected_index == -1:
			selected_index = idx
		else:
			if idx != selected_index and not _line_exists(selected_index, idx):
				lines.append({ "a": selected_index, "b": idx })
			selected_index = idx

	queue_redraw()

func _handle_right_click(mouse_pos: Vector2) -> void:
	var snap := _snap_to_grid(mouse_pos)
	var idx  := _find_point_at(snap)

	if idx == -1:
		_reset_path_state()
		queue_redraw()
		return

	if path_start == -1:
		path_start = idx
		path_end   = -1
		path.clear()
	elif idx != path_start:
		path_end = idx
		path = _dijkstra(path_start, path_end)
		path_start = -1
		path_end   = -1
	else:
		_reset_path_state()

	queue_redraw()

func _reset_path_state() -> void:
	path_start = -1
	path_end   = -1
	path.clear()

func _build_adjacency() -> Dictionary:
	var adj : Dictionary = {}
	for i in points.size():
		adj[i] = []
	for l in lines:
		var a = l["a"]
		var b = l["b"]
		var cost := points[a].distance_to(points[b])
		adj[a].append({ "to": b, "cost": cost })
		adj[b].append({ "to": a, "cost": cost })
	return adj

func _dijkstra(start:int, goal:int) -> Array[int]:
	if start == goal:
		return [start]

	var adj := _build_adjacency()
	var dist : Dictionary = {}
	var prev : Dictionary = {}
	var queue : Array[Dictionary] = []

	for i in points.size():
		dist[i] = INF
	dist[start] = 0.0
	queue.append({ "idx": start, "cost": 0.0 })

	while queue.size() > 0:
		var current := _pop_min(queue)
		var u = current["idx"]
		if u == goal:
			break
		for e in adj[u]:
			var v = e["to"]
			var alt = dist[u] + e["cost"]
			if alt < dist[v]:
				dist[v] = alt
				prev[v] = u
				queue.append({ "idx": v, "cost": alt })

	if not prev.has(goal):
		return []
	var path : Array[int] = [goal]
	var node := goal
	while prev.has(node):
		node = prev[node]
		path.push_front(node)
	return path

func _pop_min(queue:Array) -> Dictionary:
	var min_i = 0
	var min_cost = queue[0]["cost"]
	for i in range(1, queue.size()):
		if queue[i]["cost"] < min_cost:
			min_cost = queue[i]["cost"]
			min_i = i
	return queue.pop_at(min_i)

func _draw() -> void:
	_draw_grid()
	_draw_lines()
	_draw_path()
	_draw_points()

func _draw_grid() -> void:
	var size := get_viewport_rect().size
	var c := Color(0.15, 0.15, 0.15)
	for x in range(0, int(size.x), cell_size):
		draw_line(Vector2(x,0), Vector2(x,size.y), c, 1)
	for y in range(0, int(size.y), cell_size):
		draw_line(Vector2(0,y), Vector2(size.x,y), c, 1)

func _draw_lines() -> void:
	for d in lines:
		var p1 := points[d["a"]]
		var p2 := points[d["b"]]
		draw_line(p1, p2, line_color, line_width)

func _draw_path() -> void:
	if path.size() < 2:
		return
	for i in range(path.size()-1):
		var p1 := points[path[i]]
		var p2 := points[path[i+1]]
		draw_line(p1, p2, path_color, path_width)

func _draw_points() -> void:
	for i in points.size():
		var col
		if  i == selected_index or i == path_start:
			col = selected_color
		else:
			col = point_color
		draw_circle(points[i], point_radius, col)

func _snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		round(pos.x / cell_size) * cell_size,
		round(pos.y / cell_size) * cell_size
	)

func _find_point_at(pos: Vector2) -> int:
	for i in points.size():
		if points[i].distance_to(pos) <= point_radius:
			return i
	return -1

func _line_exists(a:int, b:int) -> bool:
	for l in lines:
		if (l["a"] == a and l["b"] == b) or (l["a"] == b and l["b"] == a):
			return true
	return false
