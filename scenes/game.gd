class_name Game extends Node2D

@onready var map: Map = $Map
@onready var entities: Node2D = $Entities
@onready var title_screen: Control = $TitleScreen
@onready var scores_container: ScoresContainer = %ScoresContainer
@onready var camera_2d: Camera2D = $Camera2D

@onready var level_label: Label = %LevelLabel
@onready var score_label: Label = %ScoreLabel

const PLAYER_ENTITY = preload("res://entities/player.tscn")

var player:Player

var spawn_rate:int
var spawn_counter:int
var shake_direction:Vector2
var shake_amount:int :
	set(value):
		shake_amount = value
		set_process(shake_amount > 0)

var score:int :
	set(value):
		score = value
		score_label.text = "Score: %s" % score

func _ready() -> void:
	shake_amount = 0
	Singletons.map_level = 1
	Singletons.max_hp = 6
	Singletons.entities_node = entities
	Singletons.game_scene = self
	
	show_title()

func _process(delta: float) -> void:
	shake_amount -= 1
	if shake_amount > 0:
		var shake_angle = randf() * PI * 2
		shake_direction = Vector2(round(cos(shake_angle) * shake_amount), round(sin(shake_angle) * shake_amount))
	else:
		shake_direction = Vector2.ZERO
	camera_2d.offset = shake_direction

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		get_viewport().set_input_as_handled()
		match Singletons.game_state:
			"title":
				start_game()
			"dead":
				show_title()

func tick() -> void:
	for monster in map.monsters:
		if (monster is not Player) and !monster.dead:
			await monster.update()
		else:
			map.remove_monster(monster)
	spawn_counter -= 1
	if spawn_counter == 0:
		map.spawn_monster()
		spawn_counter = spawn_rate
		spawn_rate -= 1
	if player.dead:
		Singletons.add_score(score, false)
		Singletons.game_state = "dead"
	else:
		player.can_act = true

func show_title() -> void:
	scores_container.update_scores()
	title_screen.show()
	Singletons.game_state = "title"

func start_game() -> void:
	title_screen.hide()
	Singletons.map_level = 1
	score = 0
	start_level(Singletons.starting_hp)
	Singletons.game_state = "running"

func start_level(player_hp:float) -> void:
	level_label.text = "Level: %s" % Singletons.map_level
	for e:Entity in entities.get_children():
		e.queue_free()
	spawn_rate = 15
	spawn_counter = spawn_rate
	map.generate_level()
	map.draw_map()
	player = PLAYER_ENTITY.instantiate().create(map.random_passable_tile())
	entities.add_child(player)
	player.hp = player_hp
	Singletons.player_node = player
	map.random_passable_tile().replace("Exit")
	player.can_act = true
