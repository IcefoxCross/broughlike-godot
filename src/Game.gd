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
	GameEngine.gameCamera = $Camera2D
	GameEngine.gameEffects = $Effects
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
	player.update()
	if player.dead:
		GameEngine.addScore(GameEngine.score, false)
		GameEngine.gameState = "dead"
	else:
		yield(get_tree().create_timer(.2), "timeout")
		player.can_act = true
	
	spawnCounter -= 1
	if spawnCounter <= 0:
		map.spawnMonster()
		spawnCounter = spawnRate
		spawnRate -= 1

func startGame():
	$TitleScreen.visible = false
	GameEngine.level = 1
	GameEngine.score = 0
	GameEngine.numSpells = 1
	startLevel(GameEngine.startingHp)
	GameEngine.gameState = "running"

func showTitle():
	GameEngine.gameState = "title"
	$TitleScreen.visible = true
	$TitleScreen/ScoresControl.drawScores()

func startLevel(playerHp, playerSpells = null):
	# Clean up
	for m in monsters.get_children():
		m.queue_free()
	spawnRate = 15
	spawnCounter = spawnRate
	map.generateLevel()
	map.drawMap()
	player = load("res://src/monsters/Player.tscn").instance()
	player.setup(map.randomEmptyTile())
	player.connect("action_done", self, "tick")
	player.hp = playerHp
	player.drawHp()
	if playerSpells:
		player.spells = playerSpells
	monsters.add_child(player)
	GameEngine.gamePlayer = player
	map.replaceTile(map.randomPassableTile(), "Exit")
	$LevelLabel.text = "Level: %s" % GameEngine.level
	drawSpells()

func drawScore():
	$ScoreLabel.text = "Score: %s" % GameEngine.score

func drawSpells():
	$SpellsLabel.text = ""
	for i in range(player.spells.size()):
		$SpellsLabel.text += "%s) %s" % [i+1, "" if player.spells[i] == null else player.spells[i]]
		if i < (player.spells.size()-1):
			$SpellsLabel.text += "\n"
