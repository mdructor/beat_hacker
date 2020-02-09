extends Node2D

var _levelActive = false
var _levels = []

class Level:
	var _name
	var _difficulty = 1
	var _beatData = []
	var _bpm
	
	func _init(name, difficulty, beatData, bpm):
		_difficulty = difficulty
		_beatData = beatData
		_bpm = bpm

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("ConfirmationDialog").popup_centered()
	

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
