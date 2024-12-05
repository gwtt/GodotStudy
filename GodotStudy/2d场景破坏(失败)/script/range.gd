extends Node
class_name IntRange
var min: int
var max: int

func _init(min_val: int, max_val: int):
	self.min = min_val
	self.max = max_val

func length() -> int:
	return max - min

func intersects(other: IntRange) -> bool:
	return !(max < other.min || min > other.max)