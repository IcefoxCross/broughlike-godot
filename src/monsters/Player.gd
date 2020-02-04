extends Monster

class_name Player

signal player_done

var can_act = false
var alive = false

var spells = []

func setup(_tile):
	print("setup")
	init(_tile, 0, 3)
	isPlayer = true
	alive = true
	can_act = true
	self.teleportCounter = 0
	
	var temp = Spells.spellList.duplicate()
	temp.shuffle()
	spells = temp.slice(0, GameEngine.numSpells-1)

func update():
	shield -= 1

func tryMove(dx, dy):
	if .tryMove(dx, dy):
		can_act = false

func die():
	.die()
	alive = false

func _unhandled_input(event):
	if GameEngine.gameState == "running" and can_act:
		get_tree().set_input_as_handled()
		var vel = Vector2.ZERO
		# Movement
		if Input.is_action_just_pressed("ui_left"):
			vel.x = -1
		elif Input.is_action_just_pressed("ui_right"):
			vel.x = 1
		elif Input.is_action_just_pressed("ui_up"):
			vel.y = -1
		elif Input.is_action_just_pressed("ui_down"):
			vel.y = 1
		
		if vel.length() > 0:
			print(vel)
			tryMove(vel.x, vel.y)
		
		# Spell casting
		var spell = 0
		if Input.is_action_just_pressed("spell1"):
			spell = 1
		elif Input.is_action_just_pressed("spell2"):
			spell = 2
		elif Input.is_action_just_pressed("spell3"):
			spell = 3
		elif Input.is_action_just_pressed("spell4"):
			spell = 4
		elif Input.is_action_just_pressed("spell5"):
			spell = 5
		elif Input.is_action_just_pressed("spell6"):
			spell = 6
		elif Input.is_action_just_pressed("spell7"):
			spell = 7
		elif Input.is_action_just_pressed("spell8"):
			spell = 8
		elif Input.is_action_just_pressed("spell9"):
			spell = 9
		
		if spell != 0:
			castSpell(spell-1)
		
		if Input.is_action_just_pressed("skip"):
			tryMove(0, 0)

func addSpell():
	var temp = Spells.spellList.duplicate()
	temp.shuffle()
	var newSpell = temp[0]
	spells.push_back(newSpell)
	GameEngine.gameScreen.drawSpells()

func castSpell(spellIndex):
	if GameEngine.gameState == "running":
		if spellIndex < spells.size():
			var spellName = spells[spellIndex]
			if spellName:
				spells[spellIndex] = null
				GameEngine.gameScreen.drawSpells()
				SoundManager.playSound("spell")
				Spells.call(spellName)
