extends Camera2D

@onready var point_light_2d: PointLight2D = $PointLight2D

var r = 50
var time = 0
func _process(delta: float) -> void:
	time += delta
	point_light_2d.global_position.x = self.global_position.x + r*cos(time)
	point_light_2d.global_position.y = self.global_position.y + r*sin(time)
	point_light_2d.look_at(self.global_position)
