extends CharacterBody2D


@export var speed : float = 50
@export var health: int = 30

var isPhaseTwo: bool = false
var player : CharacterBody2D


func _ready() -> void:
	player = %Player
	position = Vector2(100, 100)

func _physics_process(delta: float) -> void:
	if health <= 10:
		isPhaseTwo = true
		

	
	# Add the gravity.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.


func _on_teleport_timer_timeout() -> void:
	
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * 10000
	
	move_and_slide()	
	
	pass
	
