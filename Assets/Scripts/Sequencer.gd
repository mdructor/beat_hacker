extends ColorRect

var _BPM = 100
var _volume = 100
var _isPlaying = false
var _timer = false

var _sampleButtons = []
var _sequenceButtons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var sampleButton = preload("res://Assets/Scenes/SampleButton.tscn")
	var sequenceButton = preload("res://Assets/Scenes/SequenceButton.tscn")
	var y = 125
	
	for i in range(8):
		var samp_instance = sampleButton.instance()
		samp_instance.set_position(Vector2(10.0,y))
		_sampleButtons.append(samp_instance)
		add_child(_sampleButtons[i])
		
		_sequenceButtons.append([])
		var x = 64.0
		for j in range(8):
			var seq_instance = sequenceButton.instance()
			seq_instance.set_position(Vector2(x, y))
			_sequenceButtons[i].append(seq_instance)
			add_child(_sequenceButtons[i][j])
			x += 54
		y += 52# Replace with function body.
	
	initialize_sample_buttons()

func initialize_sample_buttons():
	_sampleButtons[0].initialize("Kick", "808-Kick")
	_sampleButtons[1].initialize("Snare", "808-Snare")


func _on_PlayButton_pressed():
	if (_isPlaying):
		if _timer != null:
			pass
