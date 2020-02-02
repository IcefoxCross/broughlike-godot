extends Node2D

onready var map: = $Map
onready var monsters: = $Monsters

var pos = Vector2.ZERO

var spawnRate = 0
var spawnCounter = 0

var player : Player

func _ready():
	GameEngine.gameScreen = self
	GameEngine.gameMap = map
	GameEngine.gameMonsters = monsters
	$ColorRect.modulate = Color.indigo
	$ColorRect.visible = true
	showTitle()

func _unhandled_key_input(event):
	if event.pressed:
		if GameEngine.gameState == "title":
			get_tree().set_input_as_handled()
			startGame()
		elif GameEngine.gameState == "dead":
			get_tree().set_input_as_handled()
			showTitle()

func _process(delta):
	if GameEngine.gameState == "running":
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().reload_current_scene()
		
#		var vel = Vector2.ZERO
#		if Input.is_action_just_pressed("ui_left"):
#			vel.x = -1
#		elif Input.is_action_just_pressed("ui_right"):
#			vel.x = 1
#		elif Input.is_action_just_pressed("ui_up"):
#			vel.y = -1
#		elif Input.is_action_just_pressed("ui_down"):
#			vel.y = 1
#
#		if vel.length() > 0:
#			print(vel)
#			player.tryMove(vel.x, vel.y)
#
#		if Input.is_action_just_pressed("skip"):
#			player.tryMove(0, 0)

func tick():
	for m in GameEngine.gameMap.monsters:
		if not m.dead:
			m.update()
		else:
			GameEngine.gameMap.monsters.erase(m)
			m.queue_free()
	if player.dead:
		GameEngine.gameState = "dead"
	
	spawnCounter -= 1
	if spawnCounter <= 0:
		map.spawnMonster()
		spawnCounter = spawnRate
		spawnRate -= 1

func startGame():
	$TitleScreen.visible = false
	GameEngine.level = 1
	startLevel(GameEngine.startingHp)
	GameEngine.gameState = "running"

func showTitle():
	GameEngine.gameState = "title"
	$TitleScreen.visible = true

func startLevel(playerHp):
	# Clean up
	for m in monsters.get_children():
		m.queue_free()
	spawnRate = 15
	spawnCounter = spawnRate
	map.generateLevel()
	map.drawMap()
	player = load("res://src/monsters/Player.tscn").instance()
	player.setup(map.randomPassableTile())
	player.connect("player_done", self, "tick")
	player.hp = playerHp
	monsters.add_child(player)
	GameEngine.gamePlayer = player
	map.replaceTile(map.randomPassableTile(), "Exit")
	$LevelLabel.text = "Level: %s" % GameEngine.level
