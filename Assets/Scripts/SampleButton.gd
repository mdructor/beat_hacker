extends TextureButton

var _buttonText = ""
var _sampleName = ""
var _samplePack = ""
var _volume = 0

func initialize(buttonText, sampleName, samplePack = ""):
	_buttonText = buttonText
	_sampleName = sampleName
	_samplePack = samplePack
	find_node("SampleName").set_text(_buttonText)

func _on_SampleButton_pressed():
	if _sampleName == "":
		return
	var player = find_parent("Sequencer").find_node("SampleStreamer")
	if _samplePack != "":
		player = player.find_node(_samplePack)
	player = player.find_node(_sampleName)
	if player.is_playing():
		player.stop()
	
	player.volume_db = _volume
	player.play()
	


func _on_SampleButton_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		get_node("PopupPanel").set_position(get_global_mouse_position())
		get_node("PopupPanel").show()


func _on_SampleButton_mouse_exited():
	if not self.get_global_rect().has_point(get_global_mouse_position()):
		get_node("PopupPanel").hide()


func _on_VSlider_value_changed(value):
	_volume = value
