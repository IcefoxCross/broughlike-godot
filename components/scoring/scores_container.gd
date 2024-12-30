class_name ScoresContainer extends VBoxContainer
## Handles updating the score list on the Title Screen

## Loads the score file, and displays the top 10 score, including the last run
func update_scores() -> void:
	var scores = Singletons.get_scores()
	$Titles.visible = scores.size() > 0
	if scores.size() > 0:
		var latest_score = scores.pop_back()
		scores.sort_custom(func(a, b): return b.total_score < a.total_score)
		scores.push_front(latest_score)
	for i in range(10):
		var score_row = get_node("Score%s" % (i+1)) as HBoxContainer
		if i < scores.size():
			update_score_row(score_row, scores[i])
			score_row.visible = true
		else: score_row.visible = false

## Displays the score's info on a row
func update_score_row(score_node:HBoxContainer, data) -> void:
	score_node.get_node("RunLabel").text = str(data.run)
	score_node.get_node("ScoreLabel").text = str(data.score)
	score_node.get_node("TotalLabel").text = str(data.total_score)
