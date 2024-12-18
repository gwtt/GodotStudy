extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d.material,"shader_parameter/pixelFactor", 0.1, 1)
	await get_tree().create_timer(0.1)
	tween.tween_property(sprite_2d.material,"shader_parameter/pixelFactor", 1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
