class_name Tile extends Node

var tile_position:Vector2
var sprite_index:int
var is_passable:bool
var entity:Entity

func _init(x:int, y:int, index:int, passable:bool) -> void:
	tile_position = Vector2(x, y)
	sprite_index = index
	is_passable = passable

func distance_to(other_tile:Tile) -> int:
	return abs(tile_position.x - other_tile.tile_position.x) + abs(tile_position.y - other_tile.tile_position.y)

func get_neighbor(dx:int, dy:int) -> Tile:
	return Singletons.map.get_tile(tile_position.x + dx, tile_position.y + dy)

func get_adjacent_neighbors() -> Array:
	var out = [
		get_neighbor(0, -1),
		get_neighbor(0, 1),
		get_neighbor(-1, 0),
		get_neighbor(1, 0),
	]
	out.shuffle()
	return out

func get_adjacent_passable_neighbors() -> Array:
	return get_adjacent_neighbors().filter(func(t:Tile): return t.is_passable)

func get_connected_tiles() -> Array:
	var connected_tiles = [self]
	var frontier = [self]
	while frontier.size() > 0:
		var tile = frontier.pop_back() as Tile
		var neighbors = tile.get_adjacent_passable_neighbors().filter(func(t:Tile): return !connected_tiles.has(t))
		connected_tiles.append_array(neighbors)
		frontier.append_array(neighbors)
	return connected_tiles

func replace(new_tile_type:String) -> Tile:
	var new_tile:Tile
	match new_tile_type:
		"Wall":
			new_tile = Wall.new(tile_position.x, tile_position.y)
		"Floor":
			new_tile = Floor.new(tile_position.x, tile_position.y)
	Singletons.map.tiles[tile_position.x][tile_position.y] = new_tile
	Singletons.map.draw_map()
	return Singletons.map.tiles[tile_position.x][tile_position.y]
