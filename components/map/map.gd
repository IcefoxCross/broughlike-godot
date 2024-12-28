class_name Map extends Node2D

@onready var map_tiles: TileMapLayer = $MapTiles
@onready var treasure_tiles: TileMapLayer = $TreasureTiles

var tiles:Array

var monster_types := ["bird", "snake", "tank", "eater", "jester"]
var monsters:Array[Entity]

func _ready() -> void:
	Singletons.map = self

func draw_map() -> void:
	for i in range(Singletons.NUM_TILES):
		for j in range(Singletons.NUM_TILES):
			var tile:Tile = get_tile(i, j)
			map_tiles.set_cell(Vector2(i, j), 0, Vector2(tile.sprite_index, 0))
			treasure_tiles.set_cell(Vector2(i, j), 0, Vector2(Tile.TREASURE_TILE if tile.has_treasure else -1, 0))

func generate_level() -> void:
	var timeout = 1000
	while timeout > 0:
		timeout -= 1
		if generate_tiles() == random_passable_tile().get_connected_tiles().size():
			break
	generate_monsters()
	for i in range(3):
		random_empty_tile().has_treasure = true

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

func in_bounds(x:int, y:int) -> bool:
	return (x > 0 and y > 0 and x < Singletons.NUM_TILES-1 and y < Singletons.NUM_TILES-1)

func get_tile(x:int, y:int) -> Tile:
	if in_bounds(x, y): return tiles[x][y]
	else: return Wall.new(x, y)

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

func generate_monsters() -> void:
	monsters = []
	var num_monsters = Singletons.map_level + 1
	for i in range(num_monsters):
		spawn_monster()

func spawn_monster() -> void:
	var monster_type = monster_types.pick_random()
	var monster = load("res://entities/%s.tscn" % monster_type).instantiate().create(random_passable_tile())
	Singletons.entities_node.add_child(monster)
	monsters.append(monster)

func remove_monster(monster:Entity) -> void:
	monsters.erase(monster)
	monster.queue_free()
