extends Node

class_name Tile

var tile_position: = Vector2.ZERO
var sprite: = 0
var passable: = true
var monster = null
var treasure = false setget set_treasure

func _init(x, y, _sprite, _passable):
	tile_position = Vector2(x, y)
	sprite = _sprite
	passable = _passable

func drawTile():
	GameEngine.gameMap.tilemap.set_cellv(tile_position, sprite)
	if treasure:
		GameEngine.gameMap.treasureMap.set_cellv(tile_position, 12)
	else:
		GameEngine.gameMap.treasureMap.set_cellv(tile_position, -1)
	

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
	# Filter
	var arr = getAdjacentNeighbors()
	var out = []
	for t in arr:
		if t.passable: out.append(t)
	###
	return out

func getConnectedTiles():
	var connectedTiles = [self]
	var frontier = [self]
	while frontier.size() > 0:
		var tile = frontier.pop_back()
		# Filter
		var neighbors = []
		var temp  = tile.getAdjacentPassableNeighbors()
		for t in temp:
			if not connectedTiles.has(t): neighbors.append(t)
		###
		connectedTiles += neighbors
		frontier += neighbors
	return connectedTiles

static func sort_ascending(a : Tile, b : Tile):
	if a.dist(GameEngine.gamePlayer.tile) < b.dist(GameEngine.gamePlayer.tile):
		return true
	return false

func dist(other : Tile):
	return int(abs(tile_position.x - other.tile_position.x)) + int(abs(tile_position.y - other.tile_position.y))

func stepOn(_monster):
	pass

func set_treasure(value):
	treasure = value
	if treasure:
		GameEngine.gameMap.treasureMap.set_cellv(tile_position, 12)
	else:
		GameEngine.gameMap.treasureMap.set_cellv(tile_position, -1)

func setEffect(effectSprite):
	var e = load("res://src/Effect.tscn").instance()
	GameEngine.gameEffects.add_child(e)
	e.position = tile_position * GameEngine.tileSize
	e.init(effectSprite)
