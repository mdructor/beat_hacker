extends Node

class Level:
	var _name = ""
	var _beats = []
	
class Beat:
	var _name
	var _beat_data
	var _sample_path = ""

var _levels

func _init():
	self._levels = []
	self._levels.append(Level.new())
	self._levels[0]._name = "Band Practice"
	var beat1 = Beat.new()
	beat1._name = "Earn Your (White) Stripes"
	beat1._sample_path = "whitestripessample.wav"
	self._levels[0]._beats.append(beat1)
	var beat2 = Beat.new()
	beat2._name = "We will, we will hack you!"
	self._levels[0]._beats.append(beat2)
	self._levels.append(Level.new())
	self._levels[1]._name = "Local Gig"