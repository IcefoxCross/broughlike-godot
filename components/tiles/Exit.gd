class_name Exit extends Tile

const EXIT_INDEX = 11

func _init(x:int, y:int) -> void:
	super(x, y, EXIT_INDEX, true)

func step_on(other_entity:Entity) -> void:
	if other_entity is Player:
		AudioManager.play_sound("NewLevel")
		if Singletons.map_level == Singletons.num_levels:
			Singletons.add_score(Singletons.game_scene.score, true)
			Singletons.game_scene.show_title()
		else:
			Singletons.map_level += 1
			Singletons.game_scene.start_level(min(Singletons.max_hp, Singletons.player_node.hp + 1))
