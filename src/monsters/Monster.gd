extends Node2D

class_name Monster

var sprite = 0
var hp = 0
var tile : Tile = null

var isPlayer = false
var dead = false
var attackedThisTurn = false
var stunned = false

func init(_tile, _sprite, _hp):
	move(_tile)
	sprite = _sprite
	hp = _hp
	
	$Sprite.frame = sprite
	drawHp()

func tryMove(dx, dy):
	var newTile = tile.getNeighbor(dx,dy)
	if newTile.passable:
		if not newTile.monster:
			move(newTile)
		else:
			if isPlayer != newTile.monster.isPlayer:
				newTile.monster.stunned = true
				attackedThisTurn = true
				newTile.monster.hit(1)
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
	if stunned:
		stunned = false
		return
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

func drawHp():
	for h in $HP.get_children():
		h.visible = h.get_index() < hp

func hit(damage):
	hp -= damage
	drawHp()
	if hp <= 0:
		die()

func die():
	dead = true
	tile.monster = null
	$Sprite.frame = 1

func heal(damage):
	hp = min(GameEngine.maxHp, hp + damage)
	drawHp()
