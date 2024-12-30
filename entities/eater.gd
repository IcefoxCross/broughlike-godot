class_name Eater extends Entity
## Eater Entity class

func create(new_tile:Tile, _sprite_index:int=7, starting_hp:int=1) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	sprite_color = Color("4D9B92")
	return self

## If there is a Wall Tile in bounds, destroys it and heals half a point, else it uses basic Update
func do_stuff() -> void:
	var neighbors = tile.get_adjacent_neighbors().filter(func(t:Tile):
		return !t.is_passable and Singletons.map.in_bounds(t.tile_position.x, t.tile_position.y))
	if neighbors.size() > 0:
		neighbors.front().replace("Floor")
		heal(0.5)
	else:
		super()
