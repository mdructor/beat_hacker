extends TextureButton

var _buttonText = ""
var _sampleName = ""
var _samplePack = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initialize(buttonText, sampleName, samplePack = ""):
	_buttonText = buttonText
	_sampleName = sampleName
	_samplePack = samplePack



