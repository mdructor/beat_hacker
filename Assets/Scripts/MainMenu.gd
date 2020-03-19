extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var titleHasCursor = true
var CURSOR_TICK_RATE = 0.6

var FUN_TICK_RATE = 2

var funButtons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var cursorTimer = Timer.new()
	cursorTimer.set_wait_time(CURSOR_TICK_RATE)
	cursorTimer.connect("timeout", self, "cursorTick")
	add_child(cursorTimer)
	cursorTimer.start()
	
	var funButtonTimer = Timer.new()
	funButtonTimer.set_wait_time(FUN_TICK_RATE)
	funButtonTimer.connect("timeout", self, "funButtonTick")
	add_child(funButtonTimer)
	funButtonTick()
	funButtonTimer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for but in funButtons:
		var pos = but.get_begin()
		pos.x -= 50 * delta
		but.set_begin(pos)

func cursorTick():
	if (titleHasCursor):
		get_node("ColorRect/Title").text = "beat hacker"
		titleHasCursor = false
	else:
		get_node("ColorRect/Title").text = "beat hacker|"
		titleHasCursor = true

func funButtonTick():
	# spawn new ones
	var toSpawn = []
	for i in range(4):
		toSpawn.append((int(rand_range(0, 2)) == 1))
	for y in range(4):
		if toSpawn[y]:
			funButtons.append(load("res://Assets/Scenes/FunButton.tscn").instance())
			funButtons.back().set_begin(Vector2(1125, 250 + 75 * y))
			get_node("ColorRect/FunContainer").add_child(funButtons.back())
			

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_LevelSelectButton_pressed():
	get_tree().change_scene("res://Assets/Scenes/LevelSelect.tscn")


func _on_SequencerButton_pressed():
	get_tree().change_scene("res://Assets/Scenes/SequencerView.tscn")
