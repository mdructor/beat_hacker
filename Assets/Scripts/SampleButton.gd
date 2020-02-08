extends TextureButton

var _buttonText = ""
var _sampleName = ""
var _samplePack = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func initialize(buttonText, sampleName, samplePack = ""):
	_buttonText = buttonText
	_sampleName = sampleName
	_samplePack = samplePack
	find_node("SampleName").text = _buttonText
		

func _on_SampleButton_pressed():
	var player = find_parent("SamplePlayer")
	if _samplePack != "":
		player = player.find_child(_samplePack)
	player = player.find_child(_sampleName)
	player.play()
