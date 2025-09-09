extends Sprite2D

@onready var point_light_2d: PointLight2D = $"../../Camera2D/PointLight2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.look_at(point_light_2d.global_position)
