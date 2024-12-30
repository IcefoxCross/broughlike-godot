class_name Entity extends Node2D
## Base Entity class, can explore the Map and interact with other Entities

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var current_hp: HFlowContainer = $CurrentHP

const TELEPORT_INDEX = 10
const TWEEN_TIME = 0.2

var sprite_color:Color
var dead:bool = false
var attacked_this_turn:bool
var stunned:bool
var move_offset:Vector2
var last_move:Vector2
var bonus_attack:int
## As long as this value is over 0, the Entity cannot take damage
var shield:int :
	set(value):
		shield = max(0, value)

## The Entity is inactive while the value is over 0
var teleport_counter:int :
	set(value):
		teleport_counter = max(0, value)
		sprite_2d.frame = TELEPORT_INDEX if teleport_counter > 0 else sprite_index
		if sprite_color: sprite_2d.modulate = Color.WHITE if teleport_counter > 0 else sprite_color
		current_hp.visible = teleport_counter == 0

## Current Entity sprite index from the sheet
var sprite_index:int :
	set(value):
		sprite_index = value
		if sprite_2d != null:
			sprite_2d.frame = sprite_index

## HP value, updates the life bar
var hp:float :
	set(value):
		hp = value
		if current_hp != null:
			for hp_val:TextureRect in current_hp.get_children():
				hp_val.visible = hp_val.get_index() < hp

## Current Tile is on
var tile:Tile = null

## Loads values from constructor and defaults others
func _ready() -> void:
	sprite_index = sprite_index
	hp = hp
	teleport_counter = 2
	move_offset = Vector2.ZERO
	last_move = Vector2.LEFT
	bonus_attack = 0
	shield = 0

## Sets initial values before entering Node Tree
func create(new_tile:Tile, _sprite_index:int, starting_hp:int) -> Entity:
	move(new_tile)
	sprite_index = _sprite_index
	hp = starting_hp
	return self

## If there is a Passable Tile in given direction, Move to that Tile, if it has a rival Entity, Hit it
func try_move(dx:int, dy:int) -> bool:
	var new_tile = tile.get_neighbor(dx, dy)
	if new_tile.is_passable:
		last_move = Vector2(dx, dy)
		if new_tile.entity == null:
			await move(new_tile)
		elif (self is Player) != (new_tile.entity is Player):
			if new_tile.entity.teleport_counter > 0: return false
			else:
				attacked_this_turn = true
				new_tile.entity.stunned = true
				new_tile.entity.hit(1 + bonus_attack)
				bonus_attack = 0
				Singletons.game_scene.shake_amount = 5
				move_offset = tile.tile_position.direction_to(new_tile.tile_position) / 2
				var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "position", tile.tile_position * Singletons.TILE_SIZE, TWEEN_TIME)\
					.from((tile.tile_position + move_offset) * Singletons.TILE_SIZE)
				await  tween.finished
				move_offset = Vector2.ZERO
		return true
	else: return false

## Move the Entity to a new Tile, updating its info
func move(new_tile:Tile) -> void:
	if tile != null:
		tile.entity = null
		move_offset = Vector2(new_tile.tile_position.x - tile.tile_position.x, new_tile.tile_position.y - tile.tile_position.y)
	tile = new_tile
	tile.entity = self
	if move_offset != Vector2.ZERO:
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", move_offset * Singletons.TILE_SIZE, TWEEN_TIME).as_relative()
		await  tween.finished
		move_offset = Vector2.ZERO
	else: position = tile.tile_position * Singletons.TILE_SIZE
	tile.step_on(self)

## Receive damage, Die if the result HP is 0
func hit(damage:float) -> void:
	if teleport_counter > 0: return
	if shield > 0: return
	hp -= damage
	if hp <= 0:
		die()
	if self is Player: AudioManager.play_sound("Hit1")
	else: AudioManager.play_sound("Hit2")

## Remove itself from the Map and Tile
func die() -> void:
	dead = true
	tile.entity = null
	sprite_index = 1
	sprite_2d.visible = self is Player

## Recover HP, up to 6 total
func heal(damage:float) -> void:
	if teleport_counter > 0: return
	hp = min(Singletons.max_hp, hp + damage)

## Update states and perform actions
func update() -> void:
	if stunned or teleport_counter > 0:
		teleport_counter = max(teleport_counter - 1, 0)
		stunned = false
		return
	await do_stuff()

## Default Entity action, try moving or attacking in a random direction
func do_stuff() -> void:
	var neighbors = tile.get_adjacent_passable_neighbors().filter(func(t:Tile): return !t.entity or t.entity is Player)
	if neighbors.size() > 0:
		neighbors.sort_custom(func(a:Tile, b:Tile):
			return a.distance_to(Singletons.player_node.tile) < b.distance_to(Singletons.player_node.tile))
		var new_tile = neighbors.front() as Tile
		var tile_direction = tile.tile_position.direction_to(new_tile.tile_position)
		await try_move(tile_direction.x, tile_direction.y)
