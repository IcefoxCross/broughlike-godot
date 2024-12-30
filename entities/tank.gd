class_name Tank extends Entity
## Tank Entity class

func create(new_tile:Tile, _sprite_index:int=6, starting_hp:int=2) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	sprite_color = Color("2D7DA9")
	return self

## Only calls basic Update every other turn
func update() -> void:
	var started_stunned = stunned
	super()
	if !started_stunned:
		stunned = true
