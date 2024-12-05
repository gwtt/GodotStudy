extends Node2D
class_name TerrainLayer
const CHUNK_SIZE = 64

var chunks: Dictionary = {}  # Vector2i -> Chunk
var original_texture: Texture2D

func _init(texture: Texture2D):
	original_texture = texture
	position = Vector2.ZERO  # 确保从左上角开始
	_initialize_chunks()

func _initialize_chunks() -> void:
	var width = original_texture.get_width()
	var chunk_count = ceil(width / float(CHUNK_SIZE))
	
	for i in chunk_count:
		var chunk_pos = Vector2i(i, 0)
		var chunk = Chunk.new(original_texture, chunk_pos)
		chunks[chunk_pos] = chunk
		add_child(chunk)
		chunk.position = Vector2(i * CHUNK_SIZE, 0)

func destroy_at(pos: Vector2, radius: int) -> void:
	# 将全局坐标转换为局部坐标
	var local_pos = to_local(pos)
	print("Destroying at local position: ", local_pos)  # 调试信息
	
	var affected_chunks = _get_affected_chunks(local_pos, radius)
	print("Affected chunks: ", affected_chunks)  # 调试信息
	
	for chunk_pos in affected_chunks:
		if chunks.has(chunk_pos):
			chunks[chunk_pos].destroy_at(pos, radius)

func _get_affected_chunks(pos: Vector2, radius: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var start_chunk = int(floor((pos.x - radius) / float(CHUNK_SIZE)))
	var end_chunk = int(ceil((pos.x + radius) / float(CHUNK_SIZE)))
	
	for i in range(start_chunk, end_chunk + 1):
		result.append(Vector2i(i, 0))
	
	return result
