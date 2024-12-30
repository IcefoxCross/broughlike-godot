class_name Floor extends Tile
## Passable Tile, can hold Entities and Treasure

const FLOOR_INDEX = 2

func _init(x:int, y:int) -> void:
	super(x, y, FLOOR_INDEX, true)

## If Player steps on this Tile and it has Treasure, increases Score, Spells and spawns a new Enemy
func step_on(other_entity:Entity) -> void:
	if other_entity is Player and has_treasure:
		AudioManager.play_sound("Treasure")
		Singletons.game_scene.score += 1
		if Singletons.game_scene.score % 3 == 0 and Singletons.num_spells < 9:
			Singletons.num_spells += 1
			Singletons.player_node.add_spell()
		has_treasure = false
		Singletons.map.spawn_monster(3)
