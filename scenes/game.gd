class_name Game extends Node2D

@onready var player = $Player

const TILE_SIZE := 16

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down"): player.position.y += TILE_SIZE
	if Input.is_action_just_pressed("move_up"): player.position.y -= TILE_SIZE
	if Input.is_action_just_pressed("move_left"): player.position.x -= TILE_SIZE
	if Input.is_action_just_pressed("move_right"): player.position.x += TILE_SIZE
