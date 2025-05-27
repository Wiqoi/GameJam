extends Node2D

@export var follow_speed: float = 95.0
@export var stop_distance: float = 5.0
@export var targ_dist: float = 11.0
@export var attack_duration: float = 0.8
@export var combo_window: float = 0.2
@export var hitbox_delay: float = 0.33

var boss : CharacterBody2D
var player : CharacterBody2D

var hitbox_timer: float = 0.0
var hitbox_activated: bool = false
var target_position: Vector2 = Vector2.ZERO
var is_following: bool = true
var velocity: Vector2 = Vector2.ZERO
var attacking = false
var combo_pending = false
var attack_direction = Vector2.RIGHT
var attack_timer = 0.0
var combo_timer = 0.0
var combo_stage = 0

func _ready():
	boss = %Boss
	player = %Player
	position = Vector2(20, 0)
	if $AttackHitbox:
		$AttackHitbox.add_to_group("PlayerAttack")

func _physics_process(delta):
	var playerdist = (player.global_position - boss.global_position)
	if playerdist.length() < targ_dist:
		target_position = player.global_position
	else:
		target_position = boss.global_position
		target_position += Vector2(playerdist.x * targ_dist / playerdist.length(), playerdist.y * targ_dist / playerdist.length())

	
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
	
	if combo_timer > 0:
		combo_timer -= delta

func _process(delta):
	if Input.is_action_just_pressed("Attack"):
		if attacking and combo_timer > 0:
			combo_pending = true
		elif not attacking:
			attack()
	
	if attacking and !hitbox_activated:
		hitbox_timer += delta
		if hitbox_timer >= hitbox_delay:
			activate_hitbox()
			hitbox_activated = true
	
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attacking = false
			$AttackHitbox.get_node("CollisionShape2D").disabled = true
			if combo_pending:
				execute_combo()
			else:
				reset_combo()
				$Sword.play("Idle")

func activate_hitbox():
	$AttackHitbox.get_node("CollisionShape2D").disabled = false

func attack():
	attacking = true
	attack_timer = attack_duration
	combo_timer = combo_window
	combo_stage = 1
	
	var mouse_position = get_global_mouse_position()
	attack_direction = (mouse_position - global_position).normalized()
	
	perform_base_attack()
	
	hitbox_timer = 0.0
	hitbox_activated = false
	$AttackHitbox.get_node("CollisionShape2D").disabled = true

func execute_combo():
	combo_pending = false
	attacking = true
	attack_timer = attack_duration * 0.8
	combo_stage += 1
	
	hitbox_timer = 0.0
	hitbox_activated = false
	$AttackHitbox.get_node("CollisionShape2D").disabled = true
	
	if abs(attack_direction.x) > abs(attack_direction.y):
		if attack_direction.x > 0:
			$Sword.play("AttackCombo")
			$AttackHitbox.set_rotation_degrees(0)
			$Sword.flip_h = false
		else:
			$Sword.play("AttackCombo")
			$AttackHitbox.set_rotation_degrees(180)
			$Sword.flip_h = true
	else:
		if attack_direction.y < 0:
			$AttackHitbox.set_rotation_degrees(-90)
			$Sword.play("AttackComboUp")
		else:
			$AttackHitbox.set_rotation_degrees(90)
			$Sword.play("AttackComboDown")

func perform_base_attack():
	if abs(attack_direction.x) > abs(attack_direction.y):
		if attack_direction.x > 0:
			$Sword.play("Attack")
			$AttackHitbox.set_rotation_degrees(0)
			$Sword.flip_h = false
		else:
			$Sword.play("Attack")
			$AttackHitbox.set_rotation_degrees(180)
			$Sword.flip_h = true
	else:
		if attack_direction.y < 0:
			$AttackHitbox.set_rotation_degrees(-90)
			$Sword.play("AttackUp")
		else:
			$AttackHitbox.set_rotation_degrees(90)
			$Sword.play("AttackDown")

func reset_combo():
	$Sword.set_rotation_degrees(0)
	combo_stage = 0
	combo_pending = false
	combo_timer = 0.0    
