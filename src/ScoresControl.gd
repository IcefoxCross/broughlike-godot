extends Control

var score_children

func _ready():
	score_children = get_children()
	score_children.pop_front()

func drawScores():
	# Clean up
	for s in score_children:
		for l in s.get_children():
			l.text = ""
	var scores = GameEngine.loadScores()
	visible = scores.size() > 0
	if scores.size() > 0:
		var newestScore = scores.pop_back()
		scores.sort_custom(self, "sort_descending")
		scores.push_front(newestScore)
		
		for i in range(min(10, scores.size())):
			score_children[i].get_node("Label").text = str(scores[i].run)
			score_children[i].get_node("Label2").text = str(scores[i].score)
			score_children[i].get_node("Label3").text = str(scores[i].totalScore)

static func sort_descending(a, b):
	if a.totalScore > b.totalScore:
		return true
	return false
