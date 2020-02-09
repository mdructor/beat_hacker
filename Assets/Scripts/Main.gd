extends Node2D

onready var starTex = preload("res://Assets/Images/star.png")
onready var starFillTex = preload("res://Assets/Images/star_fill.png")

var _levelActive = false
var _levels = []
var _metronomeTick = 0

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

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("ConfirmationDialog").popup_centered()
	createLevels()
	for i in range(_levels.size()):
		get_node("LevelList").add_item(_levels[i]._name)

func createLevels():
	# Create beat data
	var lvl1Data = [Vector2(0,0),Vector2(0,4),Vector2(0,8),Vector2(0,12)]
	var lvl2Data = [Vector2(0,0),Vector2(0,2),Vector2(1,4),Vector2(0,8),
					Vector2(0,10),Vector2(1,12)]
	var lvl3Data = [Vector2(0,0),Vector2(2,0),Vector2(2,2),Vector2(1,4),
					Vector2(2,4),Vector2(2,6),Vector2(0,8),Vector2(2,8),
					Vector2(2,10),Vector2(1,12),Vector2(2,12),Vector2(2,14)]
	
	var lvl1 = Level.new("earn your stripes", 1, lvl1Data, 120)
	var lvl2 = Level.new("we will hack u", 1, lvl2Data, 81)
	var lvl3 = Level.new("weezer type beat", 2, lvl3Data, 115)
	
	_levels.append(lvl1)
	_levels.append(lvl2)
	_levels.append(lvl3)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LevelList_item_selected(index):
	var starsToFill = _levels[index]._difficulty
	for i in range(3):
		var s = "DiffStar" + str(i)
		find_node(s).set_texture(starTex)
	for i in range(starsToFill):
		var s = "DiffStar" + str(i)
		find_node(s).set_texture(starFillTex)
	


func _on_StartButton_pressed():
	if _levelActive:
		find_node("StartButton").set_text("Start")
		_levelActive = false
	else:
		if find_node("LevelList").is_anything_selected():
			find_node("StartButton").set_text("Quit")
			_levelActive = true
			var index = find_node("LevelList").get_selected_items()[0]
			startNewLevel(index)
		

func startNewLevel(index):
	var active_level = _levels[index]
	find_node("Sequencer").set_bpm(active_level._bpm)
	find_node("CountdownPopup").popup()
	var metronome_tick = 1.0 / (active_level._bpm / 60.0)
	var _timer = Timer.new()
	_timer.connect("timeout", self, "metronomePlayTick")
	_timer.set_one_shot(false)
	add_child(_timer)
	_timer.start(metronome_tick)

func metronomePlayTick():
	get_node("Sequencer/SampleStreamer/Metronome").play()
	get_node("CountdownPopup/CountLabel").set_text(str(4-_metronomeTick))
	_metronomeTick += 1
	if _metronomeTick == 5:
		get_node("CountdownPopup").hide()
		_metronomeTick = 0
