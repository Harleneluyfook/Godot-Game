extends Node3D

@export var treat_scenes : Array[PackedScene]
@export var delay_seconds : float = 0.5
@onready var spawn_points = $SpawnPoints.get_children()

func _ready():
	randomize()
	spawn_new_treat()

func spawn_new_treat():
	if treat_scenes.is_empty():
		return
	if spawn_points.is_empty():
		print("NO SPAWN POINTS")
		return

	var treat_index = randi() % treat_scenes.size()
	var spawn_index = randi() % spawn_points.size()

	var new_treat = treat_scenes[treat_index].instantiate()

	add_child(new_treat)

	new_treat.global_position = spawn_points[spawn_index].global_position

	new_treat.connect("treat_collected", _on_treat_collected)

func _on_treat_collected():
	await get_tree().create_timer(delay_seconds).timeout
	spawn_new_treat()
	
func get_random_position() -> Vector3:
	if spawn_points.is_empty():
		return Vector3.ZERO
	
	var random_index = randi() % spawn_points.size()
	return spawn_points[random_index].global_position
