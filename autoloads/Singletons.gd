extends Node

## Reference to Map Node
var map:Map
## Reference to Entities (Player/Enemies) Node
var entities_node:Node2D
## Reference to Player Node
var player_node:Player
## Reference to Game Node
var game_scene:Game

## Total number of Tiles per row/column
var NUM_TILES := 9
## Size of each Tile in pixels
var TILE_SIZE = 16

## Current Map level
var map_level:int
## Current number of Spells
var num_spells:int
## Maximum HP value
var max_hp:int

## Starting HP for each run
var starting_hp = 3
## Maximum number of levels per run
var num_levels = 6
## Current Game state
var game_state = "loading"

#region Scoring
## Path for save file in disk
const SAVE_PATH = "user://scores.save"

## Loads save file from disk, returns array with scores (points, run number, total points, completed run)
func get_scores() -> Array:
	var scores_file:Array
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		scores_file = file.get_var()
	else:
		scores_file = []
	return scores_file

## Loads save file, adds new score, saved file to disk
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
