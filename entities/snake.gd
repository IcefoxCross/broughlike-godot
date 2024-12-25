class_name Snake extends Entity

func create(new_tile:Tile, _sprite_index:int=5, starting_hp:int=1) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	sprite_color = Color("A78CE1")
	return self

func do_stuff() -> void:
	attacked_this_turn = false
	super()
	if !attacked_this_turn:
		super()
