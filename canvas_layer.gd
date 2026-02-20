extends CanvasLayer

var score = 0

@onready var score_label = $ScoreLabel

func add_score():
	score += 1
	score_label.text = "Score: " + str(score) + "/10"

	if score >= 10:
		get_node("/root/Main").level_complete()
