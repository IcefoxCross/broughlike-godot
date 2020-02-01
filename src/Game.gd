extends Node2D

onready var map: = $Map
onready var monsters: = $Monsters

var pos = Vector2.ZERO

var player : Player

func _ready():
	GameEngine.gameMap = map
	GameEngine.gameMonsters = monsters
	$ColorRect.modulate = Color.indigo
	map.generateLevel()
	map.drawMap()
	player = load("res://src/monsters/Player.tscn").instance()
	player.setup(map.randomPassableTile())
	player.connect("player_done", self, "tick")
	monsters.add_child(player)
	GameEngine.gamePlayer = player

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
		player.tryMove(vel.x, vel.y)

func tick():
	for m in GameEngine.gameMap.monsters:
		if not m.dead:
			m.update()
		else:
			m.queue_free()
