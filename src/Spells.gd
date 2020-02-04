extends Node

signal spell_done

var spellList = ["WOOP", "QUAKE", "MAELSTROM", "MULLIGAN", "AURA", "DASH",
				"DIG", "KINGMAKER", "ALCHEMY", "POWER", "BUBBLE",
				"BRAVERY", "BOLT", "CROSS", "EX"]

# Teleport Player to a random free space
func WOOP():
	GameEngine.gamePlayer.can_act = false
	GameEngine.gamePlayer.move(GameEngine.gameMap.randomPassableTile())

# Damage all characters the more walls they're next to
func QUAKE():
	GameEngine.gamePlayer.can_act = false
	for i in range(GameEngine.numTiles):
		for j in range(GameEngine.numTiles):
			var tile = GameEngine.gameMap.getTile(i,j)
			if tile.monster:
				var numWalls = 4 - tile.getAdjacentPassableNeighbors().size()
				tile.monster.hit(numWalls*2)
	GameEngine.gameCamera.shakeAmount = 20
	yield(get_tree().create_timer(.3), "timeout")
	GameEngine.gameScreen.tick()

# Teleport all characters to a random free space
func MAELSTROM():
	GameEngine.gamePlayer.can_act = false
	for m in GameEngine.gameMap.monsters:
		m.move(GameEngine.gameMap.randomPassableTile())
		m.teleportCounter = 2
	yield(get_tree().create_timer(.3), "timeout")
	GameEngine.gameScreen.tick()

# Reset the level with all your spells, but only 1 HP
func MULLIGAN():
	GameEngine.gameScreen.startLevel(1, GameEngine.gamePlayer.spells)

func AURA():
	GameEngine.gamePlayer.can_act = false
	for t in GameEngine.gamePlayer.tile.getAdjacentNeighbors():
		t.setEffect(13)
		if t.monster:
			t.monster.heal(1)
	GameEngine.gamePlayer.tile.setEffect(13)
	GameEngine.gamePlayer.heal(1)
	yield(get_tree().create_timer(.5), "timeout")
	GameEngine.gameScreen.tick()

# Move the player forward until hits a wall or enemy, causing damage around
func DASH():
	var newTile = GameEngine.gamePlayer.tile
	while true:
		var testTile = newTile.getNeighbor(GameEngine.gamePlayer.lastMove.x, GameEngine.gamePlayer.lastMove.y)
		if testTile.passable and not testTile.monster:
			newTile = testTile
		else:
			break
	if GameEngine.gamePlayer.tile != newTile:
		GameEngine.gamePlayer.can_act = false
		GameEngine.gamePlayer.move(newTile)
		for t in newTile.getAdjacentNeighbors():
			if t.monster:
				t.setEffect(14)
				t.monster.stunned = true
				t.monster.hit(1)
	else:
		GameEngine.gameScreen.tick()

# Replaces all inner walls with floors and heal 2 HP
func DIG():
	GameEngine.gamePlayer.can_act = false
	for i in range(1, GameEngine.numTiles-1):
		for j in range(1, GameEngine.numTiles-1):
			var tile = GameEngine.gameMap.getTile(i,j)
			if not tile.passable:
				GameEngine.gameMap.replaceTile(tile, "Floor")
	GameEngine.gamePlayer.tile.setEffect(13)
	GameEngine.gamePlayer.heal(2)
	yield(get_tree().create_timer(.5), "timeout")
	GameEngine.gameScreen.tick()

# Heal all monsters and generate a treasure on their tile
func KINGMAKER():
	GameEngine.gamePlayer.can_act = false
	for m in GameEngine.gameMap.monsters:
		m.heal(1)
		m.tile.treasure = true
	yield(get_tree().create_timer(.2), "timeout")
	GameEngine.gameScreen.tick()

# Turn all adjacent inner walls into floor with treasure
func ALCHEMY():
	GameEngine.gamePlayer.can_act = false
	for t in GameEngine.gamePlayer.tile.getAdjacentNeighbors():
		if not t.passable and GameEngine.gameMap.inBounds(t.tile_position.x,t.tile_position.y):
			GameEngine.gameMap.replaceTile(t, "Floor")
			GameEngine.gameMap.getTile(t.tile_position.x,t.tile_position.y).treasure = true
	yield(get_tree().create_timer(.2), "timeout")
	GameEngine.gameScreen.tick()

# Next player attack does 6 damage
func POWER():
	GameEngine.gamePlayer.can_act = false
	GameEngine.gamePlayer.bonusAttack = 5
	yield(get_tree().create_timer(.2), "timeout")
	GameEngine.gameScreen.tick()

# Duplicate spell to the empty slot below
func BUBBLE():
	GameEngine.gamePlayer.can_act = false
	for i in range(GameEngine.gamePlayer.spells.size()-1, 0, -1):
		if GameEngine.gamePlayer.spells[i] == null:
			GameEngine.gamePlayer.spells[i] = GameEngine.gamePlayer.spells[i-1]
		GameEngine.gameScreen.drawSpells()
	yield(get_tree().create_timer(.2), "timeout")
	GameEngine.gameScreen.tick()

# Shields the player form attacks for the next 2 turns, and stuns enemies
func BRAVERY():
	GameEngine.gamePlayer.can_act = false
	GameEngine.gamePlayer.shield = 2
	for m in GameEngine.gameMap.monsters:
		m.stunned = true
	GameEngine.gameScreen.tick()

# Shoots a lightning in the facing direction
func BOLT():
	GameEngine.gamePlayer.can_act = false
	boltTravel(GameEngine.gamePlayer.lastMove, 15+abs(GameEngine.gamePlayer.lastMove.y), 4)
	yield(get_tree().create_timer(.5), "timeout")
	GameEngine.gameScreen.tick()

# Shoots lightning in the cardinal directions
func CROSS():
	GameEngine.gamePlayer.can_act = false
	var directions = [Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2.RIGHT]
	for d in directions:
		boltTravel(d, 15+abs(d.y), 2)
	yield(get_tree().create_timer(.5), "timeout")
	GameEngine.gameScreen.tick()

# Shoots lightning in the diagonal directions
func EX():
	GameEngine.gamePlayer.can_act = false
	var directions = [Vector2(-1,-1), Vector2(1,1), Vector2(-1,1), Vector2(1,-1)]
	for d in directions:
		boltTravel(d, 14, 3)
	yield(get_tree().create_timer(.5), "timeout")
	GameEngine.gameScreen.tick()

func boltTravel(direction, effect, damage):
	var newTile = GameEngine.gamePlayer.tile
	while true:
		var testTile = newTile.getNeighbor(direction.x, direction.y)
		if testTile.passable:
			newTile = testTile
			if newTile.monster:
				newTile.monster.hit(damage)
			newTile.setEffect(effect)
		else:
			break
