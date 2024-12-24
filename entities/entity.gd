class_name Entity extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var sprite_index:int
var hp:int
var dead:bool = false

var tile:Tile = null

func _ready() -> void:
	sprite_2d.frame = sprite_index

func create(new_tile:Tile, _sprite_index:int, starting_hp:int) -> Entity:
	move(new_tile)
	sprite_index = _sprite_index
	hp = starting_hp
	return self

func try_move(dx:int, dy:int) -> bool:
	var new_tile = tile.get_neighbor(dx, dy)
	if new_tile.is_passable:
		if new_tile.entity == null:
			move(new_tile)
		return true
	else: return false

func move(new_tile:Tile) -> void:
	if tile != null:
		tile.entity = null
	tile = new_tile
	tile.entity = self
	position = tile.tile_position * Singletons.TILE_SIZE

func update() -> void:
	do_stuff()

func do_stuff() -> void:
	var neighbors = tile.get_adjacent_passable_neighbors().filter(func(t:Tile): return !t.entity or t.entity is Player)
	if neighbors.size() > 0:
		neighbors.sort_custom(func(a:Tile, b:Tile):
			return a.distance_to(Singletons.player_node.tile) < b.distance_to(Singletons.player_node.tile))
		var new_tile = neighbors.front() as Tile
		var tile_direction = tile.tile_position.direction_to(new_tile.tile_position)
		try_move(tile_direction.x, tile_direction.y)
