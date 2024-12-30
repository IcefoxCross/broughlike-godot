class_name Snake extends Entity
## Snake Entity class

func create(new_tile:Tile, _sprite_index:int=5, starting_hp:int=1) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	sprite_color = Color("A78CE1")
	return self

## Performs two Update actions, only attacking once
func do_stuff() -> void:
	attacked_this_turn = false
	await super()
	if !attacked_this_turn:
		await super()
