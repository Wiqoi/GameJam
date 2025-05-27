extends CharacterBody2D


@export var speed : float = 80
@export var health: int = 30
@export var teleport_dist : float = 100.0


var isPhaseTwo: bool = false
var isTeleporting: bool = false
var player : CharacterBody2D
var movementDirection: Vector2 = Vector2.ZERO


func _ready() -> void:
	$AnimatedSprite2D.animation = "bossIdle"
	player = %Player
	position = Vector2(100, 100)

func _physics_process(delta: float) -> void:
	if $AnimatedSprite2D.animation != "bossTeleportDisappear":
		var distToPlayer = (global_position - player.global_position).length()
		if distToPlayer >= teleport_dist:
			movementDirection = (player.global_position - global_position).normalized()
			velocity = movementDirection * speed
			move_and_slide()	
			
			if movementDirection && velocity:
				pass
				if abs(movementDirection.y) > abs(movementDirection.x):
					if movementDirection.y < 0:
						if $AnimatedSprite2D.animation != "bossBack":
							$AnimatedSprite2D.animation = "bossBack"
					elif movementDirection.y > 0:
						if $AnimatedSprite2D.animation != "bossFront":
							$AnimatedSprite2D.animation = "bossFront"
				elif abs(movementDirection.x) > abs(movementDirection.y):
					if movementDirection.x < 0:
						if $AnimatedSprite2D.animation != "bossLeft":
							$AnimatedSprite2D.animation = "bossLeft"
					elif movementDirection.x > 9:
						if $AnimatedSprite2D.animation != "bossRight":
							$AnimatedSprite2D.animation = "bossRight"



					

	# Add the gravity.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

func _on_teleport_timer_timeout() -> void:
	isTeleporting = true
	
	$AnimatedSprite2D.play("bossTeleportDisappear")
	
	
	move_and_slide()	
	
	pass
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "bossTeleportDisappear":
		global_position = player.global_position

		
		$AnimatedSprite2D.play("bossTeleportReappear")



func _on_hurtbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	if area.is_in_group("PlayerAttack"):
		health -= Global.playerDmg
		
		if (health < 0):
			die()

func die():
	queue_free()
			# die
