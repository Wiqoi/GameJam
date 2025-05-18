extends Node2D

@export var follow_speed: float = 200.0
@export var stop_distance: float = 5.0
@export var attack_duration : float = 0.8

var target_position: Vector2 = Vector2.ZERO
var is_following: bool = true
var velocity: Vector2 = Vector2.ZERO
var attacking = false
var attack_direction = Vector2.RIGHT
var attack_timer = 0.0 

func _ready():
	position = Vector2(20, 0)
	if $AttackHitbox:
		$AttackHitbox.add_to_group("PlayerAttack")

func _physics_process(delta):
	target_position = Global.cursorPos
	
	if is_following:
		var direction = target_position - position
		var distance = direction.length()
		
		if distance < stop_distance:
			velocity = Vector2.ZERO
		else:
			velocity = direction.normalized() * follow_speed
			position += velocity * delta
	else:
		velocity = velocity.move_toward(Vector2.ZERO, follow_speed * delta)
		position += velocity * delta


func _process(delta):
	if Input.is_action_just_pressed("Attack") and not attacking:
		attack()
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attacking = false
			$Sword.play("Idle")

func attack():
	attacking = true
	attacking = true
	attack_timer = attack_duration

	var mouse_position = get_global_mouse_position()
	attack_direction = (mouse_position - global_position).normalized()

	if abs(attack_direction.x) > abs(attack_direction.y):
		if attack_direction.x > 0:
			$Sword.play("Attack")
			$Sword.flip_h = false
		else:
			$Sword.play("Attack")
			$Sword.flip_h = true
	else:
		if attack_direction.y < 0:
			$Sword.play("AttackUp")
		else:
			$Sword.play("AttackDown")
