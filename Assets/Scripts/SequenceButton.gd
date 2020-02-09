extends TextureButton

var _blueSquareDown = preload("res://Assets/Images/blue_square_down.png")
var _blueSquare = preload("res://Assets/Images/blue_square.png")
var _purpleSquare = preload("res://Assets/Images/purple_square.png")
var _pinkSquare = preload("res://Assets/Images/pink_square.png")

var _isChecked = false
var _isEnabled = true

func _ready():
	pass 

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
			texture_normal = _pinkSquare
		else:
			texture_normal = _purpleSquare
	else:
		if (_isChecked):
			texture_normal = _blueSquareDown
		else:
			texture_normal = _blueSquare
	
