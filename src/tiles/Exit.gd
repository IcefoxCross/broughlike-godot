extends Tile

class_name Exit

func _init(x, y).(x, y, 11, true):
	pass

func stepOn(_monster):
	if _monster.isPlayer:
		_monster.can_act = false
		if GameEngine.level == GameEngine.numLevels:
			GameEngine.gameScreen.showTitle()
		else:
			GameEngine.level += 1
			GameEngine.gameScreen.startLevel(min(GameEngine.maxHp, GameEngine.gamePlayer.hp+1))
