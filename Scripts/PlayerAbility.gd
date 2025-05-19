extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Skill"):
		$AnimatedSprite2D.visible = true
		go_to_cursor()
		$AnimatedSprite2D.play("AbilityMain")
		
func go_to_cursor():
	global_position = get_global_mouse_position()
