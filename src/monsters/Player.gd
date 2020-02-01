extends Monster

class_name Player

signal player_done

func setup(_tile):
	init(_tile, 0, 3)
	isPlayer = true

func tryMove(dx, dy):
	if .tryMove(dx, dy):
		emit_signal("player_done")
