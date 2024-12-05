class_name Column
var ranges: Array[IntRange] = []

func add_range(min_val: int, max_val: int) -> void:
	ranges.append(IntRange.new(min_val, max_val))

func remove_range(min_val: int, max_val: int) -> void:
	var remove_range = IntRange.new(min_val, max_val)
	var new_ranges: Array[IntRange] = []
	
	for r in ranges:
		if r.intersects(remove_range):
			if r.min < remove_range.min:
				new_ranges.append(IntRange.new(r.min, remove_range.min))
			if r.max > remove_range.max:
				new_ranges.append(IntRange.new(remove_range.max, r.max))
		else:
			new_ranges.append(r)
	
	ranges = new_ranges