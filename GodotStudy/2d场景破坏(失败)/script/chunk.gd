extends Node2D
class_name Chunk

const CHUNK_SIZE = 64

var columns: Array[Column] = []
var sub_texture: ImageTexture
var sprite: Sprite2D
var collision_body: StaticBody2D
var original_texture: Texture2D
var chunk_position: Vector2i

func _init(texture: Texture2D, pos: Vector2i):
	original_texture = texture
	chunk_position = pos
	columns.resize(CHUNK_SIZE)
	
	for i in CHUNK_SIZE:
		columns[i] = Column.new()
	
	sprite = Sprite2D.new()
	sprite.centered = false
	add_child(sprite)
	
	collision_body = StaticBody2D.new()
	collision_body.collision_layer = 1
	collision_body.collision_mask = 1
	add_child(collision_body)
	
	_initialize_from_texture()
	update_visuals()
	update_collision()

func _initialize_from_texture() -> void:
	var image = original_texture.get_image()
	var start_x = chunk_position.x * CHUNK_SIZE
	var threshold = 0.5
	
	for x in CHUNK_SIZE:
		var current_range_start = -1
		
		for y in image.get_height():
			var color = image.get_pixel(start_x + x, y)
			
			if color.a > threshold:
				if current_range_start == -1:
					current_range_start = y
			elif current_range_start != -1:
				columns[x].add_range(current_range_start, y)
				current_range_start = -1
		
		if current_range_start != -1:
			columns[x].add_range(current_range_start, image.get_height())

func update_visuals() -> void:
	var image = Image.create(CHUNK_SIZE, original_texture.get_height(), false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	
	var orig_image = original_texture.get_image()
	
	var start_x = chunk_position.x * CHUNK_SIZE
	for x in CHUNK_SIZE:
		if start_x + x >= orig_image.get_width():
			break
		for y in orig_image.get_height():
			var color = orig_image.get_pixel(start_x + x, y)
			image.set_pixel(x, y, color)
	
	sub_texture = ImageTexture.create_from_image(image)
	sprite.texture = sub_texture

func update_collision() -> void:
	# 清除旧的碰撞形状
	for child in collision_body.get_children():
		child.queue_free()
	
	# 创建一个矩形碰撞形状，大小与实际可见区域匹配
	var shape = RectangleShape2D.new()
	
	# 计算当前chunk的实际宽度（不超过原始纹理宽度）
	var actual_width = min(
		CHUNK_SIZE,
		original_texture.get_width() - (chunk_position.x * CHUNK_SIZE)
	)
	
	if actual_width <= 0:
		return  # 如果宽度为0或负数，不创建碰撞形状
	
	shape.size = Vector2(actual_width, original_texture.get_height())
	
	var shape_node = CollisionShape2D.new()
	shape_node.shape = shape
	shape_node.position = Vector2(actual_width/2, original_texture.get_height()/2)
	
	collision_body.add_child(shape_node)
	
	print("Created collision shape with size: ", shape.size)
	print("Collision shape position: ", shape_node.position)
	print("Chunk position: ", position)

func destroy_at(pos: Vector2, radius: int) -> void:
	var local_pos = to_local(pos)
	print("Destroying at local position: ", local_pos)
	
	var start_x = max(0, int(floor(local_pos.x - radius)))
	var end_x = min(CHUNK_SIZE, int(ceil(local_pos.x + radius)))
	
	var modified = false
	for x in range(start_x, end_x):
		if x < 0 or x >= CHUNK_SIZE:
			continue
			
		var y_dist = sqrt(radius * radius - pow(x - local_pos.x, 2))
		if is_nan(y_dist):
			continue
			
		var y_min = int(floor(local_pos.y - y_dist))
		var y_max = int(ceil(local_pos.y + y_dist))
		
		columns[x].remove_range(y_min, y_max)
		modified = true
	
	if modified:
		update_visuals()
		update_collision()