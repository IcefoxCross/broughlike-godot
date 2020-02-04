extends Node

var sounds = {}

func _ready():
	sounds = {
		"hit1": $Hit1,
		"hit2": $Hit2,
		"newLevel": $NewLevel,
		"treasure": $Treasure,
		"spell": $Spell
	}

func playSound(sound):
	sounds[sound].play()
