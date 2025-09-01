extends Sprite2D

var colors =[ ]
var color_values = "280b21,211e2a,3c2f39,5f2444,4c3b48,284b7c,73485c,565b7d,8c6976,c85e6c,c85e6c,725b98,496f93,746a93,6664b9,8f77b7,78eaaf,a69bb7,d19da4,a990d3,97b7d6,feadc0,86c6d9,bcd9fe,a6e4ea,a6e4ee,fcd4d4,dbeaff,eefaff"
var color_number = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colors = color_values.split(",")
	
	for i in colors:
		%ColorRect.modulate= Color(colors[color_number - 1])
		print("uniform vec4 color" + str(color_number) + " = vec4(" + str(%ColorRect.modulate.r) + "," + str(%ColorRect.modulate.g) + "," + str(%ColorRect.modulate.b) + ",1.0);")
		color_number += 1
