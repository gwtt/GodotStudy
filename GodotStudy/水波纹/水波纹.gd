extends Node
@onready var sprite_2d: Sprite2D = $Sprite2D

var shader_material

func _ready():
	# 获取Sprite2D节点上的ShaderMaterial（假设节点名为sprite）
	shader_material = sprite_2d.get_material()

func _process(delta):
	# 每一帧更新time变量来实现波纹动画
	if shader_material:
		var new_time = shader_material.get_shader_parameter("time") + delta
		shader_material.set_shader_parameter("time", new_time)
