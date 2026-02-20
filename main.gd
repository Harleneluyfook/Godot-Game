extends Node3D

@onready var timer = $Timer
@onready var timer_bar = $CanvasLayer/TimerBar
@onready var score_label = $CanvasLayer/ScoreLabel

var time_left = 35
var require_score = 10
var score = 0

func _ready():
	timer.wait_time = 1
	timer.one_shot = false
	timer.start()
	timer.timeout.connect(_on_timer_timeout)
	timer_bar.max_value = time_left
	timer_bar.value = time_left

func _on_timer_timeout():
	time_left -= 1
	timer_bar.value = time_left
	update_timer_color()
	if time_left <= 0:
		game_over()

func update_timer_color():
	var percent = float(time_left) / timer_bar.max_value
	var fill_style = timer_bar.get_theme_stylebox("fill")
	
	if percent > 0.6:
		fill_style.bg_color = Color.GREEN
	elif percent > 0.3:
		fill_style.bg_color = Color.YELLOW
	else:
		fill_style.bg_color = Color.RED
		
func game_over():
	get_tree().paused = true
	print("GAME OVER")

func level_complete():
	get_tree().paused = true
	print("LEVEL COMPLETE")
