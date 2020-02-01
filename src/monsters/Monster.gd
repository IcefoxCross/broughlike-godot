extends Node2D

class_name Monster

var sprite = 0
var hp = 0
var tile : Tile = null

var isPlayer = false
var dead = false

func init(_tile, _sprite, _hp):
	move(_tile)
	sprite = _sprite
	hp = _hp
	
	$Sprite.frame = sprite

func tryMove(dx, dy):
	var newTile = tile.getNeighbor(dx,dy)
	if newTile.passable:
		if not newTile.monster:
			move(newTile)
		return true
	else:
		return false

func move(_tile):
	if tile:
		tile.monster = null
	tile = _tile
	var pos = Vector2(tile.tile_position.x, tile.tile_position.y)
	position = pos * GameEngine.tileSize
	tile.monster = self

func update():
	doStuff()

func doStuff():
	# Filter
	var arr = tile.getAdjacentPassableNeighbors()
	var neighbors = []
	for tile in arr:
		if not tile.monster or tile.monster.isPlayer:
			neighbors.append(tile)
	###
	if neighbors.size() > 0:
		neighbors.sort_custom(Tile, "sort_ascending")
		var newTile = neighbors[0]
		tryMove(newTile.tile_position.x - tile.tile_position.x, newTile.tile_position.y - tile.tile_position.y)
