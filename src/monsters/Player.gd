extends Monster

class_name Player

signal player_done

var can_act = false
var alive = false

func setup(_tile):
	print("setup")
	init(_tile, 0, 3)
	isPlayer = true
	alive = true
	can_act = true
	self.teleportCounter = 0

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
		
		if Input.is_action_just_pressed("skip"):
			tryMove(0, 0)
