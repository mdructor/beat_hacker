extends Node2D

onready var levelData = load("res://Assets/Scripts/LevelData.gd").new()

var selectionLabels = []

func _ready():
	var i = 0
	var y = 100
	for level in levelData._levels:
		var levelLabel = get_node("LevelLabel").duplicate()
		levelLabel.text = "Level " + str(i) + ": " + level._name
		levelLabel.rect_position = Vector2(100, y)
		levelLabel.show()
		add_child(levelLabel)
		selectionLabels.append(selectionLabels)
		y += 50
		for beat in level._beats:
			var beatLabel = get_node("BeatLabel").duplicate()
			beatLabel.text = beat._name
			beatLabel.rect_position = Vector2(125, y)
			beatLabel.connect("pressed", self, "_on_BeatLabel_gui_input")
			beatLabel.show()
			add_child(beatLabel)
			selectionLabels.append(beatLabel)
			y += 30
		y += 20
		i += 1

func _on_BackButton_pressed():
	get_tree().change_scene("res://Assets/Scenes/MainMenu.tscn")


func _on_BeatLabel_gui_input():
	get_tree().change_scene("res://Assets/Scenes/LevelView.tscn")
