extends Control

var _blueSquareDown = preload("res://Assets/Images/blue_square_down.png")
var _blueSquare = preload("res://Assets/Images/blue_square.png")
var _purpleSquare = preload("res://Assets/Images/purple_square.png")
var _pinkSquare = preload("res://Assets/Images/pink_square.png")

var _isEnabled = true

var state = load("res://Assets/Scripts/SequenceButtonState.gd").new()

func _ready():
	get_node("PopupMenu").add_check_item("Split")

func _on_MainButton_pressed():
	state.state[0] = !state.state[0]
	updateView()

func check(on):
	if on:
		state.state[0] = true
		if state._isSplit:
			state.state[1] = true
	else:
		state.state[0] = false
		if state.isSplit:
			state.state[1] = false
	updateView()

func setStateAndUpdateView(state):
	self.state = state
	updateView()

func updateView():
	if state.isSplit:
		get_node("MainButton").rect_scale = Vector2(0.5, 1)
		get_node("SplitButton").show()
		get_node("PopupMenu").set_item_checked(0, true)
	else:
		get_node("MainButton").rect_scale = Vector2(1, 1)
		get_node("SplitButton").hide()
		get_node("PopupMenu").set_item_checked(0, false)
	if (state.state[0]):
		get_node("MainButton").texture_normal = _blueSquareDown
	else:
		get_node("MainButton").texture_normal = _blueSquare
	if (state.state[1]):
		get_node("SplitButton").texture_normal = _blueSquareDown
	else:
		get_node("SplitButton").texture_normal = _blueSquare
	
func _light_up(flag):
	if (flag):
		if (state.state[0]):
			get_node("MainButton").texture_normal = _pinkSquare
		else:
			get_node("MainButton").texture_normal = _purpleSquare
		if (state.state[1]):
			get_node("SplitButton").texture_normal = _pinkSquare
		else:
			get_node("SplitButton").texture_normal = _purpleSquare	
	else:
		updateView()


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
		state.isSplit = false
		state.state[1] = false
		updateView()
	else:
		state.isSplit = true
		updateView()

func _on_SplitButton_pressed():
	state.state[1] = !state.state[1]
	updateView()
