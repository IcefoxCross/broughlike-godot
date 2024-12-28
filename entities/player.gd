class_name Player extends Entity

func _ready() -> void:
	super()
	teleport_counter = 0

func create(new_tile:Tile, _sprite_index:int=0, starting_hp:int=3) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	return self

func try_move(dx:int, dy:int) -> bool:
	if super(dx, dy):
		Singletons.game_scene.tick()
		return true
	else: return false
