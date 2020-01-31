extends Node2D

var tileSize = 16
var numTiles = 9
var uiWidth = 4

var pos = Vector2.ZERO


func _ready():
	$ColorRect.modulate = Color.indigo
	$Sprite.position = pos

func _process(delta):
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
		$Sprite.position += vel * tileSize
