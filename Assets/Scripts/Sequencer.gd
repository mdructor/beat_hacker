extends ColorRect

var _BPM = 120
var _volume = 100
var _isPlaying = false
var _timer = false
var _tickCount = 0

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
	_sampleButtons[2].initialize("HatClosed", "808-HatClosed")
	_sampleButtons[3].initialize("HatOpen", "808-HatOpen")
	_sampleButtons[4].initialize("Clap", "808-Clap")
	_sampleButtons[5].initialize("Cymbal", "808-Cymbal")


func _on_PlayButton_pressed():
	if (_isPlaying):
		_timer.stop()
		remove_child(_timer)
		find_node("PlayButton").find_node("PlayLabel").set_text("Play")
		
		for i in range(8):
			for j in range(8):
				_sequenceButtons[i][j]._light_up(false)
		_tickCount = 0
	else:
		_timer = Timer.new()
		var bps = _BPM * 1.0 / 60.0
		var tick_rate = bps / 4.0
		_timer.connect("timeout", self, "_on_play_tick")
		_timer.set_one_shot(false)
		_timer
		add_child(_timer)
		_timer.start(tick_rate)
		find_node("PlayButton").find_node("PlayLabel").set_text("Stop")
	_isPlaying = !_isPlaying
		
func _on_play_tick():
	for i in range(8):
		_sequenceButtons[i][_tickCount]._light_up(true)
		
		if _tickCount == 0:
			_sequenceButtons[i][7]._light_up(false)
		else:
			_sequenceButtons[i][_tickCount-1]._light_up(false)
			
		if _sequenceButtons[i][_tickCount]._isChecked:
			_sampleButtons[i]._on_SampleButton_pressed()
	
	if (_tickCount == 7):
		_tickCount = 0
	else:
		_tickCount += 1


func _on_ClearButton_pressed():
	for i in range(8):
		for j in range(8):
			_sequenceButtons[i][j].check(false)
