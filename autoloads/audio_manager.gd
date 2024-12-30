extends Node

## Finds a Sound Node with the same id, and plays its audio
func play_sound(sound_id:String):
	var node = get_node(sound_id) as AudioStreamPlayer
	if node:
		node.play()
