extends TextureButton

var _blueSquareDown = preload("res://Assets/Images/blue_square_down.png")
var _blueSquare = preload("res://Assets/Images/blue_square.png")
var _darkBlueSquare = preload("res://Assets/Images/dark_blue_square.png")
var _redSquare = preload("res://Assets/Images/red_square.png")

var _isChecked = false
var _isEnabled = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SequenceButton_pressed():
	if (_isChecked):
		texture_normal = _blueSquare
	else:
		texture_normal = _blueSquareDown
		
	_isChecked = !_isChecked

func set_state(state):
	_isEnabled = state
	
func _light_up(flag):
	if (flag):
		if (_isChecked):
			texture_normal = _redSquare
		else:
			texture_normal = _darkBlueSquare
	else:
		if (_isChecked):
			texture_normal = _blueSquareDown
		else:
			texture_normal = _blueSquare
	
