class_name Jester extends Entity

func create(new_tile:Tile, _sprite_index:int=8, starting_hp:int=2) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	sprite_color = Color("C646FF")
	return self
