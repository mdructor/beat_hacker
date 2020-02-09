extends TextureButton

var _buttonText = ""
var _sampleName = ""
var _samplePack = ""

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
		
	player.play()
