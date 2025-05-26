extends CharacterBody2D


@export var speed : float = 80
@export var health: int = 30

var isPhaseTwo: bool = false
var isTeleporting: bool = false
var player : CharacterBody2D
var movementDirection: Vector2 = Vector2.ZERO

func _ready() -> void:
	player = %Player
	position = Vector2(100, 100)

func _physics_process(delta: float) -> void:
	if health <= 10:
		isPhaseTwo = true
		
	if isPhaseTwo == false:
		var distToPlayer = (global_position - player.global_position).length()
		if distToPlayer >= 60:
			movementDirection = (player.global_position - global_position).normalized()
			velocity = movementDirection * speed

			move_and_slide()	


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

	
