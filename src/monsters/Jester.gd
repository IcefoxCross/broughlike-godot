extends Monster

class_name Jester

func setup(_tile):
	init(_tile, 8, 2)

func doStuff():
	var neighbors = tile.getAdjacentPassableNeighbors()
	if neighbors.size() > 0:
		tryMove(neighbors[0].tile_position.x - tile.tile_position.x, neighbors[0].tile_position.y - tile.tile_position.y)
