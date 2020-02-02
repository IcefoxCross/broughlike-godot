extends Tile

class_name Floor

func _init(x, y).(x, y, 2, true):
	pass

func stepOn(monster):
	if monster.isPlayer and treasure:
		GameEngine.score += 1
		set_treasure(false)
		GameEngine.gameMap.spawnMonster()
