extends Node

## List of Spells, with their callback function, returns if a game tick must pass after execution
var spells = {
	## WOOP: Teleport to a random free tile
	"WOOP": func() -> bool:
		Singletons.player_node.can_act = false
		await Singletons.player_node.move(Singletons.map.random_passable_tile())
		return true,
	## QUAKE: Damages every enemy on map relative to number of adjacent walls
	"QUAKE": func() -> bool:
		for i in range(Singletons.NUM_TILES):
			for j in range(Singletons.NUM_TILES):
				var tile:Tile = Singletons.map.get_tile(i, j)
				if tile.entity:
					var num_walls = 4 - tile.get_adjacent_passable_neighbors().size()
					tile.entity.hit(num_walls * 2)
		Singletons.game_scene.shake_amount = 20
		await create_tween().tween_interval((20.0 + 5) * get_process_delta_time()).finished
		return true,
	## MAELSTROM: Teleports all enemies to random tiles, resets teleport counter
	"MAELSTROM": func() -> bool:
		for m:Entity in Singletons.map.monsters:
			m.move(Singletons.map.random_passable_tile())
			m.teleport_counter = 2
		if Singletons.map.monsters.size() > 0:
			await create_tween().tween_interval(Entity.TWEEN_TIME).finished
			return false
		else: return true,
	## MULLIGAN: Restarts level with current spells, sets Player HP to 1
	"MULLIGAN": func() -> bool:
		Singletons.game_scene.start_level(1, Singletons.player_node.spells)
		return false,
	## AURA: Heals Player and adjacent enemies by 1
	"AURA": func() -> bool:
		for tile:Tile in Singletons.player_node.tile.get_adjacent_neighbors():
			tile.set_effect(13)
			if tile.entity: tile.entity.heal(1)
		Singletons.player_node.tile.set_effect(13)
		Singletons.player_node.heal(1)
		await create_tween().tween_interval(0.5).finished
		return true,
	## DASH: Moves in last direction set until last passable tile, hits and stuns adjacent enemies
	"DASH": func() -> bool:
		var new_tile:Tile = Singletons.player_node.tile
		while true:
			var test_tile:Tile = new_tile.get_neighbor(Singletons.player_node.last_move.x, Singletons.player_node.last_move.y)
			if test_tile.is_passable and !test_tile.entity:
				new_tile = test_tile
			else: break
		if Singletons.player_node.tile != new_tile:
			await Singletons.player_node.move(new_tile)
			for tile:Tile in new_tile.get_adjacent_neighbors():
				if tile.entity:
					tile.set_effect(14)
					tile.entity.stunned = true
					tile.entity.hit(1)
		var delay_time = (3.0 * get_process_delta_time()) + 5 + 0.5
		Singletons.game_scene.shake_amount = 3
		await create_tween().tween_interval(delay_time).finished
		return true,
	## DIG: Destroys every in-bounds Wall, heals Player by 2
	"DIG": func() -> bool:
		for i in range(Singletons.NUM_TILES):
			for j in range(Singletons.NUM_TILES):
				var tile:Tile = Singletons.map.get_tile(i, j)
				if !tile.is_passable:
					tile.replace("Floor")
		Singletons.player_node.tile.set_effect(13)
		Singletons.player_node.heal(2)
		await create_tween().tween_interval(0.5).finished
		return true,
	## KINGMAKER: Heal every Enemy by 1, spanws a Treasure on that Tile
	"KINGMAKER": func() -> bool:
		for m:Entity in Singletons.map.monsters:
			m.heal(1)
			m.tile.has_treasure = true
		await create_tween().tween_interval(0.5).finished
		return true,
	## ALCHEMY: Turns all adjacent in-bound Walls into Floors with Treasure
	"ALCHEMY": func() -> bool:
		for tile:Tile in Singletons.player_node.tile.get_adjacent_neighbors():
			if !tile.is_passable and Singletons.map.in_bounds(tile.tile_position.x, tile.tile_position.y):
				tile.replace("Floor").has_treasure = true
		await create_tween().tween_interval(0.5).finished
		return true,
	## POWER: Give the Player a bonus 5 Damage
	"POWER": func() -> bool:
		Singletons.player_node.bonus_attack = 5
		await create_tween().tween_interval(0.5).finished
		return true,
	## BUBBLE: Replaces every empty Spell slot with a copy of the Spell above
	"BUBBLE": func() -> bool:
		for i in range(Singletons.player_node.spells.size()-1, 0, -1):
			if Singletons.player_node.spells[i] == null:
				Singletons.player_node.spells[i] = Singletons.player_node.spells[i-1]
		Singletons.player_node.spells_updated.emit(Singletons.player_node.spells)
		await create_tween().tween_interval(0.5).finished
		return true,
	## BRAVERY: Give a Shield to the Player for 2 turns and stuns all Enemies
	"BRAVERY": func() -> bool:
		Singletons.player_node.shield = 2
		for m:Entity in Singletons.map.monsters:
			m.stunned = true
		await create_tween().tween_interval(0.5).finished
		return false,
	## BOLT: Damages all Enemies in a line from the Player's last direction
	"BOLT": func() -> bool:
		bolt_travel(Singletons.player_node.last_move, 15 + abs(Singletons.player_node.last_move.y), 4)
		await create_tween().tween_interval(0.5).finished
		return true,
	## CROSS: Damages all Enemies in a Cross pattern from the Player
	"CROSS": func() -> bool:
		var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		for dir in directions:
			bolt_travel(dir, 15 + abs(dir.y), 2)
		await create_tween().tween_interval(0.5).finished
		return true,
	## EX: Damages all Enemies in an X pattern from the Player
	"EX": func() -> bool:
		var directions = [Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1)]
		for dir in directions:
			bolt_travel(dir, 14, 3)
		await create_tween().tween_interval(0.5).finished
		return true,
}

## Returns a list with all spell keys (option to randomize the order)
func get_spell_list(random:bool = false) -> Array:
	var out = spells.keys()
	if random: out.shuffle()
	return out

## Iterates Tiles in a direction until it finds a non-passable Tile, damaging every Enemy it finds in the way
func bolt_travel(direction:Vector2, effect_index:int, damage:float) -> void:
	var new_tile:Tile = Singletons.player_node.tile
	while true:
		var test_tile:Tile = new_tile.get_neighbor(direction.x, direction.y)
		if test_tile.is_passable:
			new_tile = test_tile
			if new_tile.entity:
				new_tile.entity.hit(damage)
			new_tile.set_effect(effect_index)
		else: break
