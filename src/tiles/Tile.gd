extends Node

class_name Tile

var tile_position: = Vector2.ZERO
var sprite: = 0
var passable: = true
var monster: = false

func _init(x, y, _sprite, _passable):
	tile_position = Vector2(x, y)
	sprite = _sprite
	passable = _passable

func drawTile(tilemap : TileMap):
	tilemap.set_cellv(tile_position, sprite)

func getNeighbor(dx, dy):
	return GameEngine.gameMap.getTile(tile_position.x + dx, tile_position.y + dy)

func getAdjacentNeighbors():
	var arr = []
	arr.append(getNeighbor(0,-1))
	arr.append(getNeighbor(0,1))
	arr.append(getNeighbor(-1,0))
	arr.append(getNeighbor(1,0))
	arr.shuffle()
	return arr

func getAdjacentPassableNeighbors():
	var arr = getAdjacentNeighbors()
	var out = []
	for t in arr:
		if t.passable: out.append(t)
	return out

func getConnectedTiles():
	var connectedTiles = [self]
	var frontier = [self]
	while frontier.size() > 0:
		var tile = frontier.pop_back()
		var neighbors = []
		var temp  = tile.getAdjacentPassableNeighbors()
		for t in temp:
			if not connectedTiles.has(t): neighbors.append(t)
		connectedTiles += neighbors
		frontier += neighbors
	return connectedTiles