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
