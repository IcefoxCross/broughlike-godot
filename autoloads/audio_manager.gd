extends Node

func play_sound(sound_id:String):
	var node = get_node(sound_id) as AudioStreamPlayer
	if node:
		node.play()
