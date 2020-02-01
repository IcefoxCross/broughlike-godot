extends Monster

class_name Snake

func setup(_tile):
	init(_tile, 5, 1)

func doStuff():
	attackedThisTurn = false
	.doStuff()
	
	if not attackedThisTurn:
		.doStuff()
