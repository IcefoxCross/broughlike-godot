class_name Game extends Node2D

@onready var map: Map = $Map
@onready var entities: Node2D = $Entities

const PLAYER_ENTITY = preload("res://entities/player.tscn")

var player:Player

static var NUM_TILES := 9

func _ready() -> void:
	Singletons.map_level = 1
	Singletons.entities_node = entities
	Singletons.game_scene = self
	map.generate_level()
	map.draw_map()
	var starting_tile = map.random_passable_tile()
	player = PLAYER_ENTITY.instantiate().create(starting_tile)
	add_child(player)
	Singletons.player_node = player

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_down"): player.try_move(0, 1)
	if Input.is_action_just_pressed("move_up"): player.try_move(0, -1)
	if Input.is_action_just_pressed("move_left"): player.try_move(-1, 0)
	if Input.is_action_just_pressed("move_right"): player.try_move(1, 0)

func tick() -> void:
	for entity:Entity in entities.get_children():
		if !(entity is Player) and !entity.dead: entity.update()
		else: entity.queue_free()
