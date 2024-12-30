class_name Map extends Node2D
## Handles Tiles and Enemies inside the generated Map

## TileMap with Walls and Floor
@onready var map_tiles: TileMapLayer = $MapTiles
## TileMap with current Treasures
@onready var treasure_tiles: TileMapLayer = $TreasureTiles

## 2D Array with generated Tiles
var tiles:Array

## Types of Enemies that can be created
var monster_types := ["bird", "snake", "tank", "eater", "jester"]
## Current list of active Enemies
var monsters:Array[Entity]

func _ready() -> void:
	Singletons.map = self

## Draws Tiles and Treasures on each TileMap
func draw_map() -> void:
	for i in range(Singletons.NUM_TILES):
		for j in range(Singletons.NUM_TILES):
			var tile:Tile = get_tile(i, j)
			map_tiles.set_cell(Vector2(i, j), 0, Vector2(tile.sprite_index, 0))
			treasure_tiles.set_cell(Vector2(i, j), 0, Vector2(Tile.TREASURE_TILE if tile.has_treasure else -1, 0))

## Generates Map, with Tiles(with no islands in a seamless path), Enemies and Treasures
func generate_level() -> void:
	var timeout = 1000
	while timeout > 0:
		timeout -= 1
		if generate_tiles() == random_passable_tile().get_connected_tiles().size():
			break
	generate_monsters()
	for i in range(3):
		random_empty_tile().has_treasure = true

## Generates the Map's Tiles
func generate_tiles() -> int:
	var passable_tiles = 0
	tiles = []
	for i in range(Singletons.NUM_TILES):
		tiles.append([])
		for j in range(Singletons.NUM_TILES):
			var tile:Tile
			if (randf() < 0.3 or !in_bounds(i, j)):
				tile = Wall.new(i, j)
			else:
				tile = Floor.new(i, j)
				passable_tiles += 1
			tiles[i].append(tile)
	return passable_tiles

## Returns if the Tile in that position is within the Map's bounds
func in_bounds(x:int, y:int) -> bool:
	return (x > 0 and y > 0 and x < Singletons.NUM_TILES-1 and y < Singletons.NUM_TILES-1)

## Returns the Tile if it's within bounds, else returns a Wall
func get_tile(x:int, y:int) -> Tile:
	if in_bounds(x, y): return tiles[x][y]
	else: return Wall.new(x, y)

## Returns a random Floor Tile within the Map's bounds that has no Entity on it, or null if there's none
func random_passable_tile() -> Tile:
	var tile:Tile = null
	var timeout = 1000
	while timeout > 0:
		timeout -= 1
		var x = randi_range(0, Singletons.NUM_TILES-1)
		var y = randi_range(0, Singletons.NUM_TILES-1)
		tile = get_tile(x, y)
		if tile.is_passable and !tile.entity: return tile
	return tile

## Returns a random Floor Tile within the Map's bounds that has no Entity or Treasure on it, or null if there's none
func random_empty_tile() -> Tile:
	var tile:Tile = null
	var timeout = 1000
	while timeout > 0:
		timeout -= 1
		var x = randi_range(0, Singletons.NUM_TILES-1)
		var y = randi_range(0, Singletons.NUM_TILES-1)
		tile = get_tile(x, y)
		if tile.is_passable and !tile.entity and !tile.has_treasure: return tile
	return tile

## Spawns a number of Enemies on the Map based on the current Level
func generate_monsters() -> void:
	monsters = []
	var num_monsters = Singletons.map_level + 1
	for i in range(num_monsters):
		spawn_monster()

## Creates a random Enemy and adds it to the Map
func spawn_monster(teleport_counter:int = 2) -> void:
	var monster_type = monster_types.pick_random()
	var monster = load("res://entities/%s.tscn" % monster_type).instantiate().create(random_passable_tile())
	Singletons.entities_node.add_child(monster)
	monsters.append(monster)
	monster.teleport_counter = teleport_counter

## Deletes the selected Enemy
func remove_monster(monster:Entity) -> void:
	monsters.erase(monster)
	monster.queue_free()
