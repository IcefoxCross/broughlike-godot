class_name Game extends Node2D

@onready var map: Map = $Map
@onready var entities: Node2D = $Entities
@onready var title_screen: Control = $TitleScreen

@onready var level_label: Label = %LevelLabel

const PLAYER_ENTITY = preload("res://entities/player.tscn")

var player:Player

var spawn_rate:int
var spawn_counter:int

func _ready() -> void:
	Singletons.map_level = 1
	Singletons.max_hp = 6
	Singletons.entities_node = entities
	Singletons.game_scene = self
	
	show_title()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		match Singletons.game_state:
			"title":
				get_viewport().set_input_as_handled()
				start_game()
			"dead":
				get_viewport().set_input_as_handled()
				show_title()
			"running":
				if Input.is_action_just_pressed("move_down"): player.try_move(0, 1)
				if Input.is_action_just_pressed("move_up"): player.try_move(0, -1)
				if Input.is_action_just_pressed("move_left"): player.try_move(-1, 0)
				if Input.is_action_just_pressed("move_right"): player.try_move(1, 0)

func tick() -> void:
	for monster in map.monsters:
		if (monster is not Player) and !monster.dead: monster.update()
		else:
			map.remove_monster(monster)
	if player.dead:
		Singletons.game_state = "dead"
	spawn_counter -= 1
	if spawn_counter == 0:
		map.spawn_monster()
		spawn_counter = spawn_rate
		spawn_rate -= 1

func show_title() -> void:
	title_screen.show()
	Singletons.game_state = "title"

func start_game() -> void:
	title_screen.hide()
	Singletons.map_level = 1
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
