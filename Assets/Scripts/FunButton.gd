extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var up = false
var time_since_color_change = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	time_since_color_change += delta
	if time_since_color_change > 0.1:
		var current_color = modulate
		if (current_color.g > 1):
			up = false
		if current_color.g < 0.29:
			up = true
		if up:
			current_color.g += 0.01
		else:
			current_color.g -= 0.01
		modulate = current_color
		time_since_color_change = 0
