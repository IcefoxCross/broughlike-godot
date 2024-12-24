class_name Bird extends Entity

func create(new_tile:Tile, _sprite_index:int=4, starting_hp:int=3) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	return self
