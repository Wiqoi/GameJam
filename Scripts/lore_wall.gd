extends Control

func _on_button_pressed() -> void:
	var err = get_tree().change_scene_to_file("res://Scenes/Levels/game.tscn")
	if err != OK:
		push_error("Fail:", err)
