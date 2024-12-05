extends Node2D

var terrain_layer: TerrainLayer

func _ready():
	var texture = preload("res://2d场景破坏(失败)/sprite/Background.png")
	terrain_layer = TerrainLayer.new(texture)
	add_child(terrain_layer)
	
	# 获取视窗大小并设置缩放
	var viewport_size = get_viewport_rect().size
	var scale_x = viewport_size.x / texture.get_width()
	var scale_y = viewport_size.y / texture.get_height()
	var scale_factor = max(scale_x, scale_y)
	
	terrain_layer.scale = Vector2(scale_factor, scale_factor)
	terrain_layer.position = viewport_size / 2 - (Vector2(texture.get_width(), texture.get_height()) * scale_factor) / 2

	# 确保物理处理启用
	terrain_layer.set_physics_process(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			terrain_layer.destroy_at(get_global_mouse_position(), 20)

func _notification(what):
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		# 窗口大小改变时重新调整地形层
		var viewport_size = get_viewport_rect().size
		var scale_x = viewport_size.x / terrain_layer.original_texture.get_width()
		var scale_y = viewport_size.y / terrain_layer.original_texture.get_height()
		var scale_factor = max(scale_x, scale_y)
		
		terrain_layer.scale = Vector2(scale_factor, scale_factor)
		terrain_layer.position = viewport_size / 2 - (Vector2(terrain_layer.original_texture.get_width(), terrain_layer.original_texture.get_height()) * scale_factor) / 2