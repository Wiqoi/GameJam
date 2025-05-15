extends CharacterBody2D

@export var movement_speed : float = 500
@export var deceleration : float = 1000
var character_direction : Vector2

func _physics_process(delta):
	character_direction.x = Input.get_axis("Player_Left", "Player_Right")
	character_direction.y = Input.get_axis("Player_Up", "Player_Down")
	
	character_direction = character_direction.normalized()
	
	if character_direction.x > 0:
		$Sprite.flip_h = false
	elif character_direction.x < 0:
		$Sprite.flip_h = true
	
	if character_direction:
		velocity = character_direction * movement_speed
		if abs(character_direction.y) > abs(character_direction.x):
			if character_direction.y < 0:
				if $Sprite.animation != "WalkingUp":
					$Sprite.animation = "WalkingUp"
			else:
				if $Sprite.animation != "WalkingDown":
					$Sprite.animation = "WalkingDown"
		else:
			if $Sprite.animation != "Walking":
				$Sprite.animation = "Walking"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)
		if $Sprite.animation == "WalkingUp":
			$Sprite.animation = "IdleUp"
		if $Sprite.animation == "WalkingDown" || $Sprite.animation == "Walking":
			$Sprite.animation = "IdleDown"
	
	move_and_slide()
