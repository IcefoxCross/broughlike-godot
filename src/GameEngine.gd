extends Node

const SAVE_PATH = "user://score.save"

var save_file: = File.new()

var tileSize = 16
var numTiles = 9
var uiWidth = 4

var level = 1
var score = 0 setget set_score
var maxHp = 6

var startingHp = 3
var numLevels = 6

var gameState = "loading"

var gameMap = null
var gameMonsters = null
var gamePlayer = null
var gameScreen = null

func set_score(value):
	score = value
	if gameScreen:
		gameScreen.drawScore()

func loadScores():
	if save_file.file_exists(SAVE_PATH):
		save_file.open(SAVE_PATH, File.READ)
		var data = parse_json(save_file.get_line())["data"]
		save_file.close()
		return data
	else:
		return []

func addScore(_score, won):
	var savedScores = loadScores()
	var scoreObject = {"score": _score, "run": 1, "totalScore": _score, "active": won}
	var lastScore = savedScores.pop_back()
	if lastScore:
		if lastScore.active:
			scoreObject.run = lastScore.run + 1
			scoreObject.totalScore += lastScore.totalScore
		else:
			savedScores.push_back(lastScore)
	savedScores.push_back(scoreObject)
	
	save_file.open(SAVE_PATH, File.WRITE)
	var data = {"data": savedScores.duplicate(true)}
	save_file.store_line(to_json(data))
	save_file.close()
