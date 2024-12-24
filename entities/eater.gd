class_name Eater extends Entity

func create(new_tile:Tile, _sprite_index:int=7, starting_hp:int=1) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	sprite_color = Color("4D9B92")
	return self
