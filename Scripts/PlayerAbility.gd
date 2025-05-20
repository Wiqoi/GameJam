extends Node2D

var pastAbility = 0
var AbilityCooldownTime : float = 1.2
var AbilityCooldownTimer : float = 1.2

func _process(delta: float) -> void:
	AbilityCooldownTimer += delta
	if Global.currentPlayerAbility != pastAbility:
			if Global.currentPlayerAbility == 0:
				removeBefore()
				pastAbility = 0
				$AnimatedSprite2D.play("AbilityMain")
				$AbilityArea.get_node("CollisionShape2D").add_to_group("AbilityMain")
			if Global.currentPlayerAbility == 1:
				removeBefore()
				pastAbility = 1
				$AnimatedSprite2D.play("Bleed")
				$AbilityArea.get_node("CollisionShape2D").add_to_group("Bleed")
			if Global.currentPlayerAbility == 2:
				removeBefore()
				pastAbility = 2
				$AnimatedSprite2D.play("GroundSpike")
				$AbilityArea.get_node("CollisionShape2D").add_to_group("GroundSpike")
			if Global.currentPlayerAbility == 3:
				removeBefore()
				pastAbility = 3
				$AnimatedSprite2D.play("Heal")
				$AbilityArea.get_node("CollisionShape2D").add_to_group("Heal")
			if Global.currentPlayerAbility == 4:
				removeBefore()
				pastAbility = 4
				$AnimatedSprite2D.play("ProtectiveBox")
				$AbilityArea.get_node("CollisionShape2D").add_to_group("ProtectiveBox")
			if Global.currentPlayerAbility == 5:
				removeBefore()
				pastAbility = 5
				$AnimatedSprite2D.play("PullInDamage")
				$AbilityArea.get_node("CollisionShape2D").add_to_group("PullInDamage")
			if Global.currentPlayerAbility == 6:
				removeBefore()
				pastAbility = 6
				$AnimatedSprite2D.play("PushAway")
				$AbilityArea.get_node("CollisionShape2D").add_to_group("PushAway")
			if Global.currentPlayerAbility == 7:
				removeBefore()
				pastAbility = 7
				$AnimatedSprite2D.play("SetOnFire")
				$AbilityArea.get_node("CollisionShape2D").add_to_group("SetOnFire")
			if Global.currentPlayerAbility == 8:
				removeBefore()
				pastAbility = 8
				$AnimatedSprite2D.play("TimeFreeze")
				$AbilityArea.get_node("CollisionShape2D").add_to_group("TimeFreeze")
	if Input.is_action_just_pressed("Skill") && Global.playerSkill >= 1 && AbilityCooldownTimer > AbilityCooldownTime:
		Global.playerSkill -= 1
		AbilityCooldownTimer = 0
		$AnimatedSprite2D.visible = true
		go_to_cursor()
		if Global.currentPlayerAbility == 0:
			$AnimatedSprite2D.play("AbilityMain")
		if Global.currentPlayerAbility == 1:
			$AnimatedSprite2D.play("Bleed")
		if Global.currentPlayerAbility == 2:
			$AnimatedSprite2D.play("GroundSpike")
		if Global.currentPlayerAbility == 3:
			$AnimatedSprite2D.play("Heal")
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
			
func removeBefore():
	if pastAbility == 0:
		$AbilityArea.get_node("CollisionShape2D").remove_from_group("AbilityMain")
	if pastAbility == 1:
		$AbilityArea.get_node("CollisionShape2D").remove_from_group("Bleed")
	if pastAbility == 2:
		$AbilityArea.get_node("CollisionShape2D").remove_from_group("GwroundSpike")
	if pastAbility == 3:
		$AbilityArea.get_node("CollisionShape2D").remove_from_group("Heal")
	if pastAbility == 4:
		$AbilityArea.get_node("CollisionShape2D").remove_from_group("ProtectiveBox")
	if pastAbility == 5:
		$AbilityArea.get_node("CollisionShape2D").remove_from_group("PullInDamage")
	if pastAbility == 6:
		$AbilityArea.get_node("CollisionShape2D").remove_from_group("PushAway")
	if pastAbility == 7:
		$AbilityArea.get_node("CollisionShape2D").remove_from_group("SetOnFire")
	if pastAbility == 8:
		$AbilityArea.get_node("CollisionShape2D").remove_from_group("TimeFreeze")
			
func go_to_cursor():
	global_position = get_global_mouse_position()
