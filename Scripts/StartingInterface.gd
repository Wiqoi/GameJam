extends Control


func _on_start_game_pressed() -> void:
	var err = get_tree().change_scene_to_file("res://Scenes/Levels/game.tscn")
	if err != OK:
		push_error("Fail:", err)
		



func _on_exit_game_pressed() -> void:
	get_tree().quit()
