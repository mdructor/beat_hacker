extends TextureButton

var _blueSquareDown = preload("res://Assets/Images/blue_square_down.png")
var _blueSquare = preload("res://Assets/Images/blue_square.png")
var _purpleSquare = preload("res://Assets/Images/purple_square.png")
var _pinkSquare = preload("res://Assets/Images/pink_square.png")

var _isChecked = false
var _isEnabled = true

func _ready():
	get_node("PopupMenu").add_check_item("Split")

func _on_SequenceButton_pressed():
	if (_isChecked):
		texture_normal = _blueSquare
	else:
		texture_normal = _blueSquareDown
		
	_isChecked = !_isChecked

func check(on):
	if on:
		_isChecked = true
		texture_normal = _blueSquareDown
	else:
		_isChecked = false
		texture_normal = _blueSquare

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
	


func _on_SequenceButton_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		get_node("PopupMenu").set_position(get_global_mouse_position())
		get_node("PopupMenu").show()


func _check_for_close():
	if not self.get_global_rect().has_point(get_global_mouse_position()):
		get_node("PopupMenu").hide()

func _on_PopupMenu_mouse_exited():
	_check_for_close()

func _on_SequenceButton_mouse_exited():
	_check_for_close()


func _on_PopupMenu_index_pressed(index):
	if get_node("PopupMenu").is_item_checked(index):
		get_node("PopupMenu").set_item_checked(index, false)
		get_node("SplitButton").hide()
	else:
		get_node("PopupMenu").set_item_checked(index, true)
		self.rect_scale = Vector2(0.5, 1)
		get_node("SplitButton").show()
