class_name Tank extends Entity

func create(new_tile:Tile, _sprite_index:int=6, starting_hp:int=2) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	return self
