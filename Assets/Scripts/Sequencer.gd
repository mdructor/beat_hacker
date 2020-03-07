extends ColorRect

var _ticks = 16
var _BPM = 120
var _volume = 100
var _isPlaying = false
var _timer = false
var _tickCount = 0
var _lvl = null
var _metronomeOn = false

var _sampleButtons = []
var _sequenceButtons = []

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
		for j in range(_ticks):
			var seq_instance = sequenceButton.instance()
			seq_instance.set_position(Vector2(x, y))
			_sequenceButtons[i].append(seq_instance)
			add_child(_sequenceButtons[i][j])
			if (j+1)%4 == 0:
				x += 4.0
			x += 54
		y += 52
	
	initialize_sample_buttons()

func initialize_sample_buttons():
	_sampleButtons[0].initialize("Kick", "808-Kick")
	_sampleButtons[1].initialize("Snare", "808-Snare")
	_sampleButtons[2].initialize("HatClosed", "808-HatClosed")
	_sampleButtons[3].initialize("HatOpen", "808-HatOpen")
	_sampleButtons[4].initialize("Clap", "808-Clap")
	_sampleButtons[5].initialize("Cymbal", "808-Cymbal")
	_sampleButtons[6].initialize("TomHi", "808-TomHi")
	_sampleButtons[7].initialize("TomLo", "808-TomLo")


func _on_PlayButton_pressed():
	if (_isPlaying):
		_timer.stop()
		remove_child(_timer)
		find_node("PlayButton").find_node("PlayLabel").set_text("Play")
		
		for i in range(8):
			for j in range(_ticks):
				_sequenceButtons[i][j]._light_up(false)
		_tickCount = 0
	else:
		_timer = Timer.new()
		var bps = _BPM / 60.0
		var tick_rate = 1 / bps / 4
	
		_timer.connect("timeout", self, "_on_play_tick")
		_timer.set_one_shot(false)
		add_child(_timer)
		_timer.start(tick_rate)
		find_node("PlayButton").find_node("PlayLabel").set_text("Stop")
	_isPlaying = !_isPlaying
		
func _on_play_tick():
	for i in range(8):
		_sequenceButtons[i][_tickCount]._light_up(true)
		
		if _tickCount == 0:
			_sequenceButtons[i][_ticks-1]._light_up(false)
		else:
			_sequenceButtons[i][_tickCount-1]._light_up(false)
			
		if _sequenceButtons[i][_tickCount]._isChecked:
			_sampleButtons[i]._on_SampleButton_pressed()
			
	if (_tickCount % 4 == 0 && _metronomeOn == true):
		get_node("SampleStreamer/Metronome").play()
	
	if (_tickCount == _ticks-1):
		_tickCount = 0
	else:
		_tickCount += 1

func _on_ClearButton_pressed():
	for i in range(8):
		for j in range(_ticks):
			_sequenceButtons[i][j].check(false)

func _getChecked():
	var res = []
	for i in range(8):
		for j in range(_ticks):
			if _sequenceButtons[i][j]._isChecked:
				res.append(Vector2(i,j))
	return res

func set_bpm(bpm):
	_BPM = bpm
	find_node("BpmRect").find_node("BPMSpinner").get_line_edit().set_text(str(_BPM))

func playLevelSequence(lvl):
	_lvl = lvl
	
	if (_isPlaying):
		_timer.stop()
		remove_child(_timer)
		find_node("PlayButton").find_node("PlayLabel").set_text("Play")
		
		for i in range(8):
			for j in range(_ticks):
				_sequenceButtons[i][j]._light_up(false)
		_tickCount = 0
	else:
		_timer = Timer.new()
		var bps = _BPM / 60.0
		var tick_rate = 1 / bps / 2
	
		_timer.connect("timeout", self, "_on_level_play_tick")
		_timer.set_one_shot(false)
		add_child(_timer)
		_timer.start(tick_rate)
	_isPlaying = !_isPlaying

func _on_level_play_tick():
	for i in range(8):
		_sequenceButtons[i][_tickCount]._light_up(true)
		
		if _tickCount == 0 || _tickCount == -1:
			_sequenceButtons[i][_ticks-1]._light_up(false)
		else:
			_sequenceButtons[i][_tickCount-1]._light_up(false)
			
			
		var coords = Vector2(i, _tickCount)
		for j in _lvl._beatData:
			if j == coords:
				_sampleButtons[i]._on_SampleButton_pressed()
		
	if (_tickCount == _ticks-1):
		_tickCount = -1
	elif _tickCount == -1:
		_timer.stop()
		_tickCount = 0
		_isPlaying = false
	else:
		_tickCount += 1


func _on_BPMSpinner_value_changed(value):
	_BPM = value


func _on_MetronomeToggle_toggled(button_pressed):
	_metronomeOn = button_pressed
