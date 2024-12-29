class_name Player extends Entity

var can_act:bool

func _ready() -> void:
	super()
	teleport_counter = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and can_act:
		get_viewport().set_input_as_handled()
		if Singletons.game_state == "running":
			if Input.is_action_just_pressed("move_down"): try_move(0, 1)
			if Input.is_action_just_pressed("move_up"): try_move(0, -1)
			if Input.is_action_just_pressed("move_left"): try_move(-1, 0)
			if Input.is_action_just_pressed("move_right"): try_move(1, 0)

func create(new_tile:Tile, _sprite_index:int=0, starting_hp:int=3) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	return self

func try_move(dx:int, dy:int) -> bool:
	can_act = false
	if move_offset != Vector2.ZERO: return false
	var moved = await super(dx, dy)
	if moved:
		Singletons.game_scene.tick()
		return true
	else:
		can_act = true
		return false
