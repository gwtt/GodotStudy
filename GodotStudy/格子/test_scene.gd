extends Node2D

# ---------- 参数 ----------
@export var cell_size      : int   = 64
@export var point_radius   : float = 6.0
@export var point_color    : Color = Color.BLACK
@export var selected_color : Color = Color.RED
@export var line_color     : Color = Color.YELLOW   # 让它跟网格区分更明显
@export var line_width     : float = 3.0
# --------------------------

var points : Array[Vector2]          = []           # 所有圆心
var lines  : Array[Dictionary]       = []           # { "a": int, "b": int }
var selected_index : int             = -1           # 当前选中的圆

func _ready() -> void:
	set_process_input(true)                         # 接收全局输入

# ---------- 输入 ----------
func _input(event: InputEvent) -> void:
	if  event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		_handle_left_click(event.position)

func _handle_left_click(mouse_pos: Vector2) -> void:
	var snap : Vector2 = _snap_to_grid(mouse_pos)
	var idx  : int     = _find_point_at(snap)

	if idx == -1:
		# 空格点 ⇒ 新建圆
		points.append(snap)
		var last_index = selected_index
		selected_index = points.size() - 1
		if idx != selected_index and selected_index != 0:
			lines.append({ "a": last_index, "b": selected_index })
	else:
		if selected_index == -1:
			selected_index = idx
			

	queue_redraw()                               # 重新绘制

# ---------- 工具 ----------
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

# ---------- 绘制 ----------
func _draw() -> void:
	_draw_grid()
	_draw_lines()
	_draw_points()

func _draw_grid() -> void:
	var view_size := get_viewport_rect().size
	var c := Color(0.15, 0.15, 0.15, 1)          # 深灰
	for x in range(0, int(view_size.x), cell_size):
		draw_line(Vector2(x,0), Vector2(x,view_size.y), c, 1)
	for y in range(0, int(view_size.y), cell_size):
		draw_line(Vector2(0,y), Vector2(view_size.x,y), c, 1)

func _draw_lines() -> void:
	for d in lines:
		# 一定要用同样的键名 "a" / "b"
		var p1 : Vector2 = points[d["a"]]
		var p2 : Vector2 = points[d["b"]]
		draw_line(p1, p2, line_color, line_width)

func _draw_points() -> void:
	for i in points.size():
		var col
		if i == selected_index:
			col = selected_color
		else:
			col = point_color
		draw_circle(points[i], point_radius, col)
