extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Skill"):
		$AnimatedSprite2D.visible = true
		go_to_cursor()
		if Global.currentPlayerAbility == 0:
			$AnimatedSprite2D.play("AbilityMain")
		if Global.currentPlayerAbility == 1:
			$AnimatedSprite2D.play("Heal")
		if Global.currentPlayerAbility == 2:
			$AnimatedSprite2D.play("Bleed")
		if Global.currentPlayerAbility == 3:
			$AnimatedSprite2D.play("GroundSpike")
		if Global.currentPlayerAbility == 4:
			$AnimatedSprite2D.play("ProtectiveBox")
		if Global.currentPlayerAbility == 5:
			$AnimatedSprite2D.play("PullInDamage")
		if Global.currentPlayerAbility == 6:
			$AnimatedSprite2D.play("PushAway")
		if Global.currentPlayerAbility == 7:
			$AnimatedSprite2D.play("SetOnFire")
		if Global.currentPlayerAbility == 8:
			$AnimatedSprite2D.play("TimeFreeze")
		
func go_to_cursor():
	global_position = get_global_mouse_position()
