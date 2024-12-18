extends Node2D
@onready var health_bar: ProgressBar = $health_bar


func _ready() -> void:
	health_bar.init_health(10)
	for i in range(100):
		await get_tree().create_timer(0.5).timeout
		health_bar.health -= 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
