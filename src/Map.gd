extends Node2D

#const TILE = preload("res://src/Tile.gd")

onready var tilemap: = $TileMap

var tiles = []

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
		var x = floor(rand_range(1, GameEngine.numTiles-1))
		var y = floor(rand_range(1, GameEngine.numTiles-1))
		tile = getTile(x,y)
		if tile.passable and not tile.monster:
			return tile
	return null
