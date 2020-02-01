extends Monster

class_name Eater

func setup(_tile):
	init(_tile, 7, 1)

func doStuff():
	# Filter
	var neighbors = []
	var temp  = tile.getAdjacentNeighbors()
	for t in temp:
		if not t.passable and GameEngine.gameMap.inBounds(t.tile_position.x,t.tile_position.y):
			neighbors.append(t)
	###
	if neighbors.size() > 0:
		GameEngine.gameMap.replaceTile(neighbors[0], "Floor")
		heal(0.5)
	else:
		.doStuff()
