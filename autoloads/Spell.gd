extends Node

var spells = {
	"WOOP": func() -> bool:
		Singletons.player_node.can_act = false
		await Singletons.player_node.move(Singletons.map.random_passable_tile())
		return true,
	"QUAKE": func() -> bool:
		for i in range(Singletons.NUM_TILES):
			for j in range(Singletons.NUM_TILES):
				var tile:Tile = Singletons.map.get_tile(i, j)
				if tile.entity and tile.entity is not Player:
					var num_walls = 4 - tile.get_adjacent_passable_neighbors().size()
					tile.entity.hit(num_walls * 2)
		Singletons.game_scene.shake_amount = 20
		await create_tween().tween_interval((20.0 + 5) * get_process_delta_time()).finished
		return true,
	"MAELSTROM": func() -> bool:
		for m:Entity in Singletons.map.monsters:
			m.move(Singletons.map.random_passable_tile())
			m.teleport_counter = 2
		if Singletons.map.monsters.size() > 0:
			await create_tween().tween_interval(Entity.TWEEN_TIME).finished
			return false
		else: return true,
	"MULLIGAN": func() -> bool:
		Singletons.game_scene.start_level(1, Singletons.player_node.spells)
		return false,
	"AURA": func() -> bool:
		for tile:Tile in Singletons.player_node.tile.get_adjacent_neighbors():
			tile.set_effect(13)
			if tile.entity: tile.entity.heal(1)
		Singletons.player_node.tile.set_effect(13)
		Singletons.player_node.heal(1)
		await create_tween().tween_interval(0.5).finished
		return true,
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
	"KINGMAKER": func() -> bool:
		for m:Entity in Singletons.map.monsters:
			m.heal(1)
			m.tile.has_treasure = true
		await create_tween().tween_interval(0.5).finished
		return true,
	"ALCHEMY": func() -> bool:
		for tile:Tile in Singletons.player_node.tile.get_adjacent_neighbors():
			if !tile.is_passable and Singletons.map.in_bounds(tile.tile_position.x, tile.tile_position.y):
				tile.replace("Floor").has_treasure = true
		await create_tween().tween_interval(0.5).finished
		return true,
	"POWER": func() -> bool:
		Singletons.player_node.bonus_attack = 5
		await create_tween().tween_interval(0.5).finished
		return true,
	"BUBBLE": func() -> bool:
		for i in range(Singletons.player_node.spells.size()-1, 0, -1):
			if Singletons.player_node.spells[i] == null:
				Singletons.player_node.spells[i] = Singletons.player_node.spells[i-1]
		Singletons.player_node.spells_updated.emit(Singletons.player_node.spells)
		await create_tween().tween_interval(0.5).finished
		return true,
	"BRAVERY": func() -> bool:
		Singletons.player_node.shield = 2
		for m:Entity in Singletons.map.monsters:
			m.stunned = true
		await create_tween().tween_interval(0.5).finished
		return false,
	"BOLT": func() -> bool:
		bolt_travel(Singletons.player_node.last_move, 15 + abs(Singletons.player_node.last_move.y), 4)
		await create_tween().tween_interval(0.5).finished
		return true,
	"CROSS": func() -> bool:
		var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		for dir in directions:
			bolt_travel(dir, 15 + abs(dir.y), 2)
		await create_tween().tween_interval(0.5).finished
		return true,
	"EX": func() -> bool:
		var directions = [Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1)]
		for dir in directions:
			bolt_travel(dir, 14, 3)
		await create_tween().tween_interval(0.5).finished
		return true,
}

func get_spell_list(random:bool = false) -> Array:
	var out = spells.keys()
	if random: out.shuffle()
	return out

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
