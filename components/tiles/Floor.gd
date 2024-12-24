class_name Floor extends Tile

const FLOOR_INDEX = 2

func _init(x:int, y:int) -> void:
	super(x, y, FLOOR_INDEX, true)
