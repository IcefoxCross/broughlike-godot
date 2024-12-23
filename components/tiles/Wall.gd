class_name Wall extends Tile

const WALL_INDEX = 3

func _init(x, y) -> void:
	super(x, y, WALL_INDEX, false)
