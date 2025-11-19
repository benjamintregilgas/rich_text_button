extends MarginContainer


func _on_pause_toggled(toggled_on: bool) -> void:
	get_tree().paused = toggled_on
