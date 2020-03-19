extends Node2D

onready var levelData = load("res://Assets/Scripts/LevelData.gd").new()

var levelLabels = []
var beatButtons = []

func _ready():
	var i = 0
	for level in levelData._levels:
		var levelLabel = get_node("LevelLabel").duplicate()
		levelLabel.text = "Level " + str(i) + ": " + level._name
		levelLabel.show()
		get_node("ScrollContainer/VBoxContainer").add_child(levelLabel)
		levelLabels.append(levelLabels)
		for beat in level._beats:
			var beatBtn = get_node("BeatButton").duplicate()
			beatBtn.text = beat._name
			beatBtn.connect("pressed", self, "_on_BeatLabel_gui_input", [beat, beatBtn])
			beatBtn.show()
			get_node("ScrollContainer/VBoxContainer").add_child(beatBtn)
			beatButtons.append(beatBtn)
		i += 1

func _on_BackButton_pressed():
	get_tree().change_scene("res://Assets/Scenes/MainMenu.tscn")


func _on_BeatLabel_gui_input(beat, selected_btn):
	selected_btn.pressed = true
	for btn in beatButtons:
		if selected_btn != btn:
			btn.pressed = false
			
	get_node("SamplePlayer").stop()
	if beat._sample_path != "":
		var beat_sample = load("res://Assets/Sounds/beatsamples/" + beat._sample_path)
		get_node("SamplePlayer").stream = beat_sample
		get_node("SamplePlayer").play()
