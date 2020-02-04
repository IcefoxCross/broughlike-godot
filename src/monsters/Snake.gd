extends Monster

class_name Snake

func setup(_tile):
	init(_tile, 5, 1)

func doStuff():
	attackedThisTurn = false
	.doStuff()
	yield(self, "action_done")
	if not attackedThisTurn:
		.doStuff()
