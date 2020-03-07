extends Control

var _blueSquareDown = preload("res://Assets/Images/blue_square_down.png")
var _blueSquare = preload("res://Assets/Images/blue_square.png")
var _purpleSquare = preload("res://Assets/Images/purple_square.png")
var _pinkSquare = preload("res://Assets/Images/pink_square.png")

var _isEnabled = true

var _isChecked = [false, false]
var _isSplit = false

func _ready():
	get_node("PopupMenu").add_check_item("Split")

func _on_MainButton_pressed():
	if (_isChecked[0]):
		get_node("MainButton").texture_normal = _blueSquare
	else:
		get_node("MainButton").texture_normal = _blueSquareDown
	_isChecked[0] = !_isChecked[0]


func check(on):
	if on:
		_isChecked = true
		get_node("MainButton").texture_normal = _blueSquareDown
	else:
		_isChecked = false
		get_node("MainButton").texture_normal = _blueSquare

func set_state(state):
	_isEnabled = state
	
func _light_up(flag):
	if (flag):
		if (_isChecked[0]):
			get_node("MainButton").texture_normal = _pinkSquare
		else:
			get_node("MainButton").texture_normal = _purpleSquare
	else:
		if (_isChecked[0]):
			get_node("MainButton").texture_normal = _blueSquareDown
		else:
			get_node("MainButton").texture_normal = _blueSquare
	


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
		_isSplit = false
		_isChecked[1] = false
		get_node("SplitButton").texture_normal = _blueSquare
		get_node("PopupMenu").set_item_checked(index, false)
		get_node("MainButton").rect_scale = Vector2(1,1)
		get_node("SplitButton").hide()
	else:
		get_node("PopupMenu").set_item_checked(index, true)
		get_node("MainButton").rect_scale = Vector2(0.5, 1)
		_isSplit = true
		if _isChecked[1]:
			get_node("SplitButton").texture_normal = _blueSquareDown
		get_node("SplitButton").show()

func _on_SplitButton_pressed():
	if (_isChecked[1]):
		get_node("SplitButton").texture_normal = _blueSquare
	else:
		get_node("SplitButton").texture_normal = _blueSquareDown
	_isChecked[1] = !_isChecked[1]
