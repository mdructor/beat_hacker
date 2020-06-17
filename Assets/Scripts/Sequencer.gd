extends Node2D

var _TICKS_PER_BAR = 32    # (32nd notes)
var _MAX_BARS = 4        # Maximum number of bars available to user

var _lvl = null

var _bpm = 120            # Current beats per minute
var _isPlaying = false    # State for if the sequencer is current playing back beat
var _timer = false        # Timer for ticks
var _tickCount = 0        # Current tick while playing
var _metronomeOn = false  # Flag for metronome toggle

var _currentBar = 1       # Current bar being viewed in the sequencer
var _totalBars = 1        # Total bars selected by user range of [1 - _MAX_BARS]

var _sampleButtons = []   # Array of Sample Buttons on sequencer
var _sequenceButtons = [] # Array of touch buttons on sequencer

var SequenceButtonState = load("res://Assets/Scripts/SequenceButtonState.gd")
var _sequenceButtonState = []     # 2d array [sample index][button index]
	
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
		for j in range(_TICKS_PER_BAR / 2):
			var seq_instance = sequenceButton.instance()
			seq_instance.set_position(Vector2(x, y))
			_sequenceButtons[i].append(seq_instance)
			add_child(_sequenceButtons[i][j])
			if (j+1)%4 == 0:
				x += 4.0
			x += 54
		y += 52
	
	initialize_sample_buttons()
	initialize_sequence_state()

func _input(event):
	if event is InputEventKey: 
		for i in range(1, 9):
			if event.is_action_pressed("sample" + str(i)):
				_sampleButtons[i-1].playSample()

func initialize_sequence_state(): 
	for i in range(8):
		_sequenceButtonState.append([])
		for j in range(_TICKS_PER_BAR / 2 * _MAX_BARS):
			_sequenceButtonState[i].append(SequenceButtonState.new())

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
			for j in range(16):
				_sequenceButtons[i][j]._light_up(false)
		_tickCount = 0
	else:
		_timer = Timer.new()
		var bps = _bpm / 60.0
		var tick_rate = 1 / bps / 8
	
		_timer.connect("timeout", self, "_on_play_tick")
		_timer.set_one_shot(false)
		add_child(_timer)
		_timer.start(tick_rate)
		find_node("PlayButton").find_node("PlayLabel").set_text("Stop")
	_isPlaying = !_isPlaying
		
func _on_play_tick():
	for i in range(8):
		_sequenceButtons[i][(_tickCount % _TICKS_PER_BAR) /2]._light_up(true)
		
		if _tickCount % _TICKS_PER_BAR == 0:
			_sequenceButtons[i][15]._light_up(false)
			_currentBar = _tickCount / _TICKS_PER_BAR + 1
			if _currentBar > _totalBars:
				_currentBar = 1
			updateBarText()
			restateSequenceView()
		else:
			_sequenceButtons[i][(_tickCount % _TICKS_PER_BAR) / 2 - 1]._light_up(false)
			
		if _sequenceButtons[i][(_tickCount % _TICKS_PER_BAR) / 2].state.state[_tickCount%2]:
			_sampleButtons[i]._on_SampleButton_pressed()
			
	if _tickCount % 8 == 0 && _metronomeOn == true:
		get_node("SampleStreamer/Metronome").play()
	
	if _tickCount == _TICKS_PER_BAR * _totalBars - 1:
		_tickCount = 0
	else:
		_tickCount += 1

func _on_ClearButton_pressed():
	for i in range(8):
		for j in range(16):
			_sequenceButtons[i][j].check(false)

func _getChecked():
	var res = []
	for i in range(8):
		for j in range(16):
			if _sequenceButtons[i][j]._isChecked:
				res.append(Vector2(i,j))
	return res

func set_bpm(bpm):
	_bpm = bpm
	find_node("BpmRect/BPMSpinner").get_line_edit().set_text(str(_bpm))

func playLevelSequence(lvl):
	_lvl = lvl
	
	if (_isPlaying):
		_timer.stop()
		remove_child(_timer)
		find_node("PlayButton").find_node("PlayLabel").set_text("Play")
		
		for i in range(8):
			for j in range(16):
				_sequenceButtons[i][j]._light_up(false)
		_tickCount = 0
	else:
		_timer = Timer.new()
		var bps = _bpm / 60.0
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
			_sequenceButtons[i][15]._light_up(false)
		else:
			_sequenceButtons[i][_tickCount-1]._light_up(false)
			
			
		var coords = Vector2(i, _tickCount)
		for j in _lvl._beatData:
			if j == coords:
				_sampleButtons[i]._on_SampleButton_pressed()
		
	if _tickCount == _TICKS_PER_BAR-1:
		_tickCount = -1
	elif _tickCount == -1:
		_timer.stop()
		_tickCount = 0
		_isPlaying = false
	else:
		_tickCount += 1



func _on_BPMSpinner_value_changed(value):
	_bpm = value

func _on_MetronomeToggle_toggled(button_pressed):
	_metronomeOn = button_pressed
	
func updateBarText():
	get_node("BarRect/BarText").text = str(_currentBar) + "/" + str(_totalBars)

func updateSequencerButtons(): # NOPE NOPE NOPE TODO
	pass

func _on_TotBarUp_pressed():
	if _totalBars == _MAX_BARS:
		return
	_totalBars += 1
	updateBarText()

func _on_TotBarDwn_pressed():
	if _totalBars == 1:
		return
	_totalBars -= 1
	if _currentBar > _totalBars:
		_currentBar = _totalBars
	updateBarText()

func _on_CurBarDwn_pressed():
	if _currentBar == 1:
		return
	_currentBar -= 1
	updateBarText()
	restateSequenceView()

func _on_CurBarUp_pressed():
	if _currentBar == _totalBars:
		return
	_currentBar += 1
	updateBarText()
	restateSequenceView()
	
func signalSequenceViewChange(): # TODO
	for i in range(8):
		for j in range(_TICKS_PER_BAR / 2):
			_sequenceButtonState[i][(_currentBar - 1) * _TICKS_PER_BAR / 2 + j] = _sequenceButtons[i][j].state
			
func restateSequenceView():
	for i in range(8):
		for j in range(_TICKS_PER_BAR / 2):
			_sequenceButtons[i][j].setStateAndUpdateView(_sequenceButtonState[i][(_currentBar - 1) * _TICKS_PER_BAR / 2 + j])
