extends Node

var map:Map
var entities_node:Node2D
var player_node:Player
var game_scene:Game

var NUM_TILES := 9
var TILE_SIZE = 16

var map_level:int
var max_hp:int

var starting_hp = 3
var num_levels = 6
var game_state = "loading"

#region Scoring
const SAVE_PATH = "user://scores.save"

func get_scores() -> Array:
	var scores_file:Array
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		scores_file = file.get_var()
	else:
		scores_file = []
	return scores_file

func add_score(score:int, has_won:bool) -> void:
	var saved_scores = get_scores()
	var new_score = {"score": score, "run": 1, "total_score": score, "is_active": has_won}
	var last_score = saved_scores.pop_back()
	if last_score:
		if last_score.is_active:
			new_score.run = last_score.run + 1
			new_score.total_score += last_score.total_score
		else:
			saved_scores.append(last_score)
	saved_scores.append(new_score)
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(saved_scores)
#endregion
