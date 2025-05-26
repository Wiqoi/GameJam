extends Node2D

var pastAbility = 0
var AbilityCooldownTime : float = 1.2
var AbilityCooldownTimer : float = 1.2

func _process(delta: float) -> void:
	AbilityCooldownTimer += delta
	if Global.currentPlayerAbility != pastAbility:
			if Global.currentPlayerAbility == 1:
				removeBefore()
				pastAbility = 1
				$AbilityArea.add_to_group("AbilityMain")
			elif Global.currentPlayerAbility == 2:
				removeBefore()
				pastAbility = 2
				$AbilityArea.add_to_group("Bleed")
			elif Global.currentPlayerAbility == 3:
				removeBefore()
				pastAbility = 3
				$AbilityArea.add_to_group("GroundSpike")
			elif Global.currentPlayerAbility == 4:
				removeBefore()
				pastAbility = 4
				$AbilityArea.add_to_group("Heal")
			elif Global.currentPlayerAbility == 5:
				removeBefore()
				pastAbility = 5
				$AbilityArea.add_to_group("ProtectiveBox")
			elif Global.currentPlayerAbility == 6:
				removeBefore()
				pastAbility = 6
				$AbilityArea.add_to_group("PullInDamage")
			elif Global.currentPlayerAbility == 7:
				removeBefore()
				pastAbility = 7
				$AbilityArea.add_to_group("PushAway")
			elif Global.currentPlayerAbility == 8:
				removeBefore()
				pastAbility = 8
				$AbilityArea.add_to_group("SetOnFire")
			elif Global.currentPlayerAbility == 9:
				removeBefore()
				pastAbility = 9
				$AbilityArea.add_to_group("TimeFreeze")
				
	else:
		var frame = $AnimatedSprite2D.frame
		match frame:
			9:
				%AbilityCollision.disabled = false
			_:
				%AbilityCollision.disabled = true
				
	if Input.is_action_just_pressed("Skill") && Global.playerSkill >= 1 && AbilityCooldownTimer > AbilityCooldownTime:
		Global.playerSkill -= 1
		AbilityCooldownTimer = 0
		$AnimatedSprite2D.visible = true
		go_to_cursor()
		if Global.currentPlayerAbility == 1:
			$AnimatedSprite2D.play("AbilityMain")
		elif Global.currentPlayerAbility == 2:
			$AnimatedSprite2D.play("Bleed")
		elif Global.currentPlayerAbility == 3:
			$AnimatedSprite2D.play("GroundSpike")
		elif Global.currentPlayerAbility == 4:
			$AnimatedSprite2D.play("Heal")
		elif Global.currentPlayerAbility == 5:
			$AnimatedSprite2D.play("ProtectiveBox")
		elif Global.currentPlayerAbility == 6:
			$AnimatedSprite2D.play("PullInDamage")
		elif Global.currentPlayerAbility == 7:
			$AnimatedSprite2D.play("PushAway")
		elif Global.currentPlayerAbility == 8:
			$AnimatedSprite2D.play("SetOnFire")
		elif Global.currentPlayerAbility == 9:
			$AnimatedSprite2D.play("TimeFreeze")
			
func removeBefore():
	if pastAbility == 1:
		$AbilityArea.remove_from_group("AbilityMain")
	elif pastAbility == 2:
		$AbilityArea.remove_from_group("Bleed")
	elif pastAbility == 3:
		$AbilityArea.remove_from_group("GwroundSpike")
	elif pastAbility == 4:
		$AbilityArea.remove_from_group("Heal")
	elif pastAbility == 5:
		$AbilityArea.remove_from_group("ProtectiveBox")
	elif pastAbility == 6:
		$AbilityArea.remove_from_group("PullInDamage")
	elif pastAbility == 7:
		$AbilityArea.remove_from_group("PushAway")
	elif pastAbility == 8:
		$AbilityArea.remove_from_group("SetOnFire")
	elif pastAbility == 9:
		$AbilityArea.remove_from_group("TimeFreeze")
			
func go_to_cursor():
	global_position = get_global_mouse_position()

func _on_animated_sprite_2d_animation_finished() -> void:
	%AbilityCollision.disabled = true
