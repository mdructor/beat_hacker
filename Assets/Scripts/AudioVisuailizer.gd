extends Node2D

onready var bus = AudioServer.get_bus_index("Master")
var pinks = []
var purples = []

var x_scale = 0.4
var y_scale_max = 1.5
var y_scale_min = 0.2

func _ready():
	for i in range(6):
		pinks.append(get_node("Pink").duplicate())
		purples.append(get_node("Purple").duplicate())
		pinks[i].set_scale(Vector2(x_scale, y_scale_min))
		purples[i].set_scale(Vector2(x_scale, y_scale_min))
		pinks[i].rect_position = Vector2(i * 18, 10)
		purples[i].rect_position = Vector2(i * 18, 58)
		pinks[i].show()
		purples[i].show()
		add_child(pinks[i])
		add_child(purples[i])

func _process(delta):
	var left = AudioServer.get_bus_peak_volume_left_db(bus, 0)
	var right = AudioServer.get_bus_peak_volume_right_db(bus, 0)
	
	var y_scale = y_scale_max * left * -0.1
	y_scale = clamp(y_scale, y_scale_min, y_scale_max)
	pinks[2].set_scale(Vector2(x_scale, y_scale))
	purples[2].set_scale(Vector2(x_scale, y_scale))
	var y2 = pinks[1].get_scale().y
	y2 = y_scale-y2 * .5
	y2 = clamp(y2, y_scale_min, y_scale_max)
	pinks[1].set_scale(Vector2(x_scale, y2))
	purples[1].set_scale(Vector2(x_scale, y2))
	var y3 = pinks[0].get_scale().y
	y3 = y2-y3 * .5
	y3 = clamp(y3, y_scale_min, y_scale_max)
	pinks[0].set_scale(Vector2(x_scale, y3))
	purples[0].set_scale(Vector2(x_scale, y3))
	
	var right_scale = y_scale_max * right * -0.1
	right_scale = clamp(right_scale, y_scale_min, y_scale_max)
	pinks[3].set_scale(Vector2(x_scale, right_scale))
	purples[3].set_scale(Vector2(x_scale, right_scale))
	var y4 = pinks[4].get_scale().y
	y4 = right_scale-y4 * .5
	y4 = clamp(y4, y_scale_min, y_scale_max)
	pinks[4].set_scale(Vector2(x_scale, y4))
	purples[4].set_scale(Vector2(x_scale, y4))
	var y5 = pinks[5].get_scale().y
	y5 = y4-y5 * .5
	y5 = clamp(y5, y_scale_min, y_scale_max)
	pinks[5].set_scale(Vector2(x_scale, y5))
	purples[5].set_scale(Vector2(x_scale, y5))
	

func clamp(x, low, high):
	if x < low:
		return low
	if x > high:
		return high
	return x
	
	
