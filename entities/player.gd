class_name Player extends Entity
## Player Class, gets controlled by keyboard

signal spells_updated

var can_act:bool
var spells:Array

## Creates list of available spells
func _ready() -> void:
	super()
	teleport_counter = 0
	spells = Spell.get_spell_list(true).slice(0, Singletons.num_spells)
	spells_updated.emit(spells)

## Moves or casts spells depending on the Input pressed
func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and can_act:
		get_viewport().set_input_as_handled()
		if Singletons.game_state == "running":
			if Input.is_action_just_pressed("move_down"): try_move(0, 1)
			elif Input.is_action_just_pressed("move_up"): try_move(0, -1)
			elif Input.is_action_just_pressed("move_left"): try_move(-1, 0)
			elif Input.is_action_just_pressed("move_right"): try_move(1, 0)
			
			if Input.is_action_just_pressed("spell_1"): cast_spell(0)
			elif Input.is_action_just_pressed("spell_2"): cast_spell(1)
			elif Input.is_action_just_pressed("spell_3"): cast_spell(2)
			elif Input.is_action_just_pressed("spell_4"): cast_spell(3)
			elif Input.is_action_just_pressed("spell_5"): cast_spell(4)
			elif Input.is_action_just_pressed("spell_6"): cast_spell(5)
			elif Input.is_action_just_pressed("spell_7"): cast_spell(6)
			elif Input.is_action_just_pressed("spell_8"): cast_spell(7)
			elif Input.is_action_just_pressed("spell_9"): cast_spell(8)

## Instantiates the Player
func create(new_tile:Tile, _sprite_index:int=0, starting_hp:int=3) -> Entity:
	super(new_tile, _sprite_index, starting_hp)
	return self

## Tries moving on the Map, performs a Game Tick if successful
func try_move(dx:int, dy:int) -> bool:
	can_act = false
	if move_offset != Vector2.ZERO: return false
	var moved = await super(dx, dy)
	if moved:
		if !(tile is Exit): Singletons.game_scene.tick()
		return true
	else:
		can_act = true
		return false

## Adds a new Spell to the available list
func add_spell() -> void:
	var new_spell = Spell.get_spell_list().pick_random()
	spells.append(new_spell)
	spells_updated.emit(spells)

## Casts a spell from the list, and performs a Game Tick after it's done, if required
func cast_spell(spell_index:int) -> void:
	if spell_index < spells.size():
		var spell_name = spells[spell_index]
		if spell_name:
			spells[spell_index] = null
			spells_updated.emit(spells)
			AudioManager.play_sound("Spell")
			var has_tick = await Spell.spells[spell_name].call()
			if has_tick: Singletons.game_scene.tick()

## Updates Player's states
func update() -> void:
	shield -= 1
