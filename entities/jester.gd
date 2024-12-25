class_name Jester extends Entity

func create(new_tile:Tile, _sprite_index:int=8, starting_hp:int=2) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	sprite_color = Color("C646FF")
	return self

func do_stuff() -> void:
	var neighbors = tile.get_adjacent_passable_neighbors()
	if neighbors.size() > 0:
		try_move(neighbors.front().tile_position.x - tile.tile_position.x, neighbors.front().tile_position.y - tile.tile_position.y)
