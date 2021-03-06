extends Node2D

class Level:
	var _name = ""
	var _difficulty = 1
	var _beatData = []
	var _bpm = 120
	
	func _init(name, difficulty, beatData, bpm):
		_name = name
		_difficulty = difficulty
		_beatData = beatData
		_bpm = bpm

onready var starTex = preload("res://Assets/Images/star.png")
onready var starFillTex = preload("res://Assets/Images/star_fill.png")

var _levelActive = false
var _levels = []
var _metronomeTick = 0
var _metronomeTimer = null

func _ready():
	get_node("ConfirmationDialog").popup_centered()
	createLevels()
	for i in range(_levels.size()):
		get_node("LevelList").add_item(_levels[i]._name)

func createLevels():
	# Create beat data
	var lvl1Data = [Vector2(0,0),Vector2(0,2),Vector2(0,4),Vector2(0,6),
					Vector2(0,8),Vector2(0,10),Vector2(0,12),Vector2(0,14)]
	var lvl2Data = [Vector2(0,0),Vector2(0,1),Vector2(1,2),Vector2(0,4),
					Vector2(0,5),Vector2(1,6),Vector2(0,8),Vector2(0,9),
					Vector2(1,10),Vector2(0,12),Vector2(0,13),Vector2(1,14)]
	var lvl3Data = [Vector2(0,0),Vector2(2,0),Vector2(2,1),Vector2(2,2),
					Vector2(2,3),Vector2(2,4),Vector2(2,5),Vector2(2,6),
					Vector2(2,7),Vector2(2,8),Vector2(2,9),Vector2(2,10),
					Vector2(2,11),Vector2(2,12),Vector2(2,13),Vector2(2,14),
					Vector2(2,15),Vector2(1,2),Vector2(0,4),Vector2(1,6),
					Vector2(0,8),Vector2(1,10),Vector2(0,12),Vector2(1,14)]
	var lvl4Data = [Vector2(0,0),Vector2(0,1),Vector2(1,2),Vector2(0,4),
					Vector2(0,5),Vector2(1,6),Vector2(0,8),Vector2(0,9),
					Vector2(1,10),Vector2(0,12),Vector2(0,13),Vector2(1,14),
					Vector2(2,0),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(2,4),
					Vector2(2,5),Vector2(2,6),Vector2(2,7),Vector2(2,8),
					Vector2(2,9),Vector2(2,10),Vector2(2,11),Vector2(2,12),
					Vector2(2,13),Vector2(2,14),Vector2(3,15)]
	var lvl5Data = [Vector2(0,0),Vector2(2,0),Vector2(1,2),Vector2(2,2),Vector2(0,3),
					Vector2(2,4),Vector2(0,5),Vector2(1,6),Vector2(2,6),Vector2(2,8),
					Vector2(0,9),Vector2(1,10),Vector2(2,10),Vector2(0,12),Vector2(2,12),
					Vector2(1,14),Vector2(2,14)]
	var lvl6Data = [Vector2(1,0),Vector2(0,1),Vector2(0,2),Vector2(1,3),Vector2(0,4),
					Vector2(0,5),Vector2(1,6),Vector2(0,7),Vector2(1,8),Vector2(0,9),
					Vector2(0,10),Vector2(1,11),Vector2(0,12),Vector2(0,13),Vector2(1,14),
					Vector2(0,15),Vector2(5,0),Vector2(5,1),Vector2(5,2),Vector2(5,3),
					Vector2(5,4),Vector2(5,5),Vector2(5,6),Vector2(5,7),Vector2(5,8),
					Vector2(5,9),Vector2(5,10),Vector2(5,11),Vector2(5,12),Vector2(5,13),
					Vector2(5,14),Vector2(5,15)]
	
	var lvl1 = Level.new("Earn Your (White) Stripes", 1, lvl1Data, 120)
	var lvl2 = Level.new("We will, We will hack you!", 1, lvl2Data, 81)
	var lvl3 = Level.new("weezer type beat", 2, lvl3Data, 115)
	var lvl4 = Level.new("Smells like sooner spirit", 2, lvl4Data, 116)
	var lvl5 = Level.new("Down the beat labyrinth", 3, lvl5Data, 181)
	var lvl6 = Level.new("tfw coldplay = final boss", 3, lvl6Data,130)
	
	_levels.append(lvl1)
	_levels.append(lvl2)
	_levels.append(lvl3)
	_levels.append(lvl4)
	_levels.append(lvl5)
	_levels.append(lvl6)

func _on_LevelList_item_selected(index):
	var starsToFill = _levels[index]._difficulty
	for i in range(3):
		var s = "DiffStar" + str(i)
		find_node(s).set_texture(starTex)
	for i in range(starsToFill):
		var s = "DiffStar" + str(i)
		find_node(s).set_texture(starFillTex)
		
	var active_level = _levels[index]
	find_node("Sequencer").set_bpm(active_level._bpm)


func _on_StartButton_pressed():
	toggleStart()

func toggleStart():
	if _levelActive:
		find_node("StartButton").set_text("Start")
		_levelActive = false
		get_node("SubmitButton").disabled = true
	else:
		if find_node("LevelList").is_anything_selected():
			find_node("StartButton").set_text("Quit")
			_levelActive = true
			var index = find_node("LevelList").get_selected_items()[0]
			startNewLevel(index)
			get_node("SubmitButton").disabled = false
	
		

func _onSubmit():
	# 1.) Check current level from list selection
	# 2.) Step through the sequence buttons and save points in an array
	# 3.) Determine if beat is correct or not
	var selectedLvl = get_node("LevelList").get_selected_items()[0]
	var submission = get_node("Sequencer")._getChecked()
	
	var correct = 0
	var incorrect = 0
	
	for p1 in _levels[selectedLvl]._beatData:
		var found = false
		for p2 in submission:
			if p1 == p2:
				correct += 1
				found = true
		if !found:
			incorrect += 1
	
	for p1 in submission:
		var found = false
		for p2 in _levels[selectedLvl]._beatData:
			if p1 == p2:
				found = true
		if !found:
			incorrect += 1
	
	var resultsPopup = get_node("ResultsDialog")
	if incorrect == 0:
		resultsPopup.window_title = "Nice job!!!"
	elif incorrect < 3:
		resultsPopup.window_title = "Close one!"
	else:
		resultsPopup.window_title = "Better luck next time!"
		
	if incorrect == 0:
		get_node("CheerSound").play()
	else:
		get_node("NegSound").play()
			
		
	resultsPopup.dialog_text = str(correct) + " correct\n" + str(incorrect) + " incorrect"
	resultsPopup.popup_centered()
	
	get_node("SubmitButton").disabled = true
	toggleStart()

func startNewLevel(index):
	var active_level = _levels[index]
	var metronome_tick = 1.0 / (active_level._bpm / 60.0)
	_metronomeTimer = Timer.new()
	_metronomeTimer.connect("timeout", self, "metronomePlayTick")
	_metronomeTimer.set_one_shot(false)
	add_child(_metronomeTimer)
	_metronomeTimer.start(metronome_tick)

func metronomePlayTick():	
	if _metronomeTick == 0:
		find_node("CountdownPopup").popup()
	else:
		get_node("CountdownPopup/CountLabel").set_text(str(4-_metronomeTick))
	
	_metronomeTick += 1
	
	if _metronomeTick == 5:
		get_node("CountdownPopup").hide()
		get_node("CountdownPopup/CountLabel").set_text("4")
		_metronomeTick = 0
		_metronomeTimer.stop()
		
		var selectedLvl = get_node("LevelList").get_selected_items()[0]
		get_node("Sequencer").playLevelSequence(_levels[selectedLvl])
	else:
		get_node("Sequencer/SampleStreamer/Metronome").play()
		

