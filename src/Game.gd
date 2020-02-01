extends Node2D

onready var map: = $Map

var pos = Vector2.ZERO


func _ready():
	GameEngine.gameMap = map
	$ColorRect.modulate = Color.indigo
	map.generateLevel()
	map.drawMap()
	var startingTile = map.randomPassableTile()
	pos = Vector2(startingTile.tile_position.x, startingTile.tile_position.y)
	$Sprite.position = pos * GameEngine.tileSize
	
	

func _process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
	
	var vel = Vector2.ZERO
	if Input.is_action_just_pressed("ui_left"):
		vel.x = -1
	elif Input.is_action_just_pressed("ui_right"):
		vel.x = 1
	elif Input.is_action_just_pressed("ui_up"):
		vel.y = -1
	elif Input.is_action_just_pressed("ui_down"):
		vel.y = 1
	
	if vel.length() > 0:
		$Sprite.position += vel * GameEngine.tileSize
