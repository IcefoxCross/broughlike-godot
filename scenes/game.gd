class_name Game extends Node2D

@onready var map: Map = $Map
@onready var player = $Player

static var TILE_SIZE := 16
static var NUM_TILES := 9

func _ready() -> void:
	map.generate_level()
	map.draw_map()
	var starting_tile = map.random_passable_tile()
	player.position = starting_tile.tile_position * TILE_SIZE

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down"): player.position.y += TILE_SIZE
	if Input.is_action_just_pressed("move_up"): player.position.y -= TILE_SIZE
	if Input.is_action_just_pressed("move_left"): player.position.x -= TILE_SIZE
	if Input.is_action_just_pressed("move_right"): player.position.x += TILE_SIZE
