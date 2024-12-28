class_name Floor extends Tile

const FLOOR_INDEX = 2

func _init(x:int, y:int) -> void:
	super(x, y, FLOOR_INDEX, true)

func step_on(entity:Entity) -> void:
	if entity is Player and has_treasure:
		Singletons.game_scene.score += 1
		has_treasure = false
		Singletons.map.spawn_monster()
