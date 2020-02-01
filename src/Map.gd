extends Node2D

#const TILE = preload("res://src/Tile.gd")

onready var tilemap: = $TileMap

var tiles = []
var monsters = []

func _ready():
	randomize()

func drawMap():
	for i in range(GameEngine.numTiles):
		for j in range(GameEngine.numTiles):
			getTile(i,j).drawTile(tilemap)

func generateLevel():
	# Try to
	var timeout = 1000
	while timeout > 0:
		timeout -= 1
		if generateTiles() == randomPassableTile().getConnectedTiles().size():
			break;
	generateMonsters()

func generateTiles():
	var passableTiles = 0
	tiles = []
	for i in range(GameEngine.numTiles):
		tiles.append([])
		for j in range(GameEngine.numTiles):
			var tile
			if randf() < 0.3 or not inBounds(i,j):
				tile = Wall.new(i,j)
			else:
				tile = Floor.new(i,j)
				passableTiles += 1
			tiles[i].append(tile)
	return passableTiles

func inBounds(x,y):
	return x>0 and y>0 and x<GameEngine.numTiles-1 and y<GameEngine.numTiles-1

func getTile(x,y):
	if inBounds(x,y):
		return tiles[x][y]
	else:
		return Wall.new(x,y)

func randomPassableTile():
	var tile = null
	# Try to
	var timeout = 1000
	while timeout > 0:
		timeout -= 1
		var x = floor(rand_range(0, GameEngine.numTiles-1))
		var y = floor(rand_range(0, GameEngine.numTiles-1))
		tile = getTile(x,y)
		if tile.passable and tile.monster == null:
			return tile
	return null

func generateMonsters():
	if not monsters.empty():
		for e in monsters:
			e.queue_free()
	var numMonsters = GameEngine.level + 1
	for i in range(numMonsters):
		var m = spawnMonster()
		monsters.append(m)
		GameEngine.gameMonsters.add_child(m)

func spawnMonster():
	var monsterTypes = ["Bird", "Snake", "Tank", "Eater", "Jester"]
	var monsterType = monsterTypes[randi() % monsterTypes.size()]
	var monster = load("res://src/monsters/%s.tscn" % monsterType).instance()
	monster.setup(randomPassableTile())
	return monster

func replaceTile(oldTile, newTileType):
	var newTile
	match newTileType:
		"Floor":
			newTile = Floor.new(oldTile.tile_position.x, oldTile.tile_position.y)
		"Wall":
			newTile = Wall.new(oldTile.tile_position.x, oldTile.tile_position.y)
	tiles[oldTile.tile_position.x][oldTile.tile_position.y] = newTile
	tiles[oldTile.tile_position.x][oldTile.tile_position.y].drawTile(tilemap)
	return tiles[newTile.tile_position.x][newTile.tile_position.y]
