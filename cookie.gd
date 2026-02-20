extends Area3D

signal treat_collected

func _on_body_entered(body: Node3D) -> void:
	if body.name == "2dPlayer":

		var ui = get_node("/root/Main/CanvasLayer")
		ui.add_score()

		emit_signal("treat_collected")
		queue_free()
