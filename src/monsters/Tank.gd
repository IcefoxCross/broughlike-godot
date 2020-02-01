extends Monster

class_name Tank

func setup(_tile):
	init(_tile, 6, 2)

func update():
	var startedStunned = stunned
	.update()
	if not startedStunned:
		stunned = true
