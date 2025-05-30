extends CharacterBody2D


@export var speed : float = 100
@export var health: int = 10
@export var teleport_dist : float = 60.0


var isPhaseTwo: bool = false
var isTeleporting: bool = false
var player : CharacterBody2D
var movementDirection: Vector2 = Vector2.ZERO


func _ready() -> void:
	if !Global.bossDead:
		$AnimatedSprite2D.animation = "bossIdle"
		player = %Player
		position = Vector2(300, 100)


					

	# Add the gravity.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

func _on_teleport_timer_timeout() -> void:
	
	if !Global.bossDead:
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
		health -= 1
		Global.bossHealth -= 1
		
		if (health < 0):
			die()
		else:
			$AnimatedSprite2D.play("bossHurt")
			await $AnimatedSprite2D.animation_finished

func die():
	Global.bossDead = true
	$AnimatedSprite2D.play("bossSkullDeath")
	await $AnimatedSprite2D.animation_finished
	queue_free()
	get_tree().quit()

			# die
