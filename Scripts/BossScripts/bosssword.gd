extends Node2D

@export var follow_speed: float = 80.0
@export var stop_distance: float = 10.0
@export var targ_dist: float = 15.0
@export var attack_duration: float = 0.8
@export var combo_window: float = 0.2
@export var hitbox_delay: float = 0.33
@export var attack_range: float = 40.0

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
var playerBossDistance = Vector2.ZERO
var attack_timer = 0.0
var combo_timer = 0.0
var combo_stage = 0

var aggrattack_dist : float = 30.0
var lounge_dist : float = 40.0

func _ready():
	boss = %Boss
	player = %Player
	position = Vector2(300, 200)
	
	$AttackHitbox.add_to_group("EnemyHitbox")
	$AttackHitbox.get_node("CollisionShape2D").disabled = true 

func _physics_process(delta):
	playerBossDistance = (player.global_position - boss.global_position)
	

	if playerBossDistance.length() > 0:
		target_position = boss.global_position + playerBossDistance.normalized() * targ_dist
	else:
		target_position = boss.global_position + Vector2.RIGHT * targ_dist


	if is_following:
		var direction = target_position - position
		var distance = direction.length()
		
		if distance > stop_distance:
			velocity = direction.normalized() * follow_speed
			position += velocity * delta
		else:
			velocity = Vector2.ZERO
	else:
		velocity = velocity.move_toward(Vector2.ZERO, follow_speed * delta)
		position += velocity * delta
	
	if combo_timer > 0:
		combo_timer -= delta


func _process(delta: float) -> void:
	var distance_to_player = (position - player.global_position).length()

	if not attacking and distance_to_player < attack_range:
		attack()
	elif attacking and distance_to_player >= attack_range * 1.2:  # 放宽退出攻击的条件
		reset_attack()

	if attacking:
		attack_timer -= delta
		
		if attack_timer <= 0:
			attacking = false
			$AttackHitbox.get_node("CollisionShape2D").disabled = true
			
			if combo_pending:
				execute_combo()
			else:
				reset_combo()
				$Sword.play("Idle")
		else:
			if not hitbox_activated:
				hitbox_timer += delta
				if hitbox_timer >= hitbox_delay:
					activate_hitbox()
					hitbox_activated = true

func attack():
	attacking = true
	attack_timer = attack_duration
	combo_timer = combo_window
	combo_stage = 1
	
	attack_direction = (player.global_position - global_position).normalized()
	
	perform_base_attack()
	
	hitbox_timer = 0.0
	hitbox_activated = false
	$AttackHitbox.get_node("CollisionShape2D").disabled = true

func execute_combo():
	combo_pending = false
	attacking = true
	attack_timer = attack_duration * 0.8
	combo_stage += 1
	
	attack_direction = (player.global_position - global_position).normalized()

	hitbox_timer = 0.0
	hitbox_activated = false
	$AttackHitbox.get_node("CollisionShape2D").disabled = true

	set_attack_animation(attack_direction, true)

func perform_base_attack():
	set_attack_animation(attack_direction, false)

func set_attack_animation(direction: Vector2, is_combo: bool):
	if abs(direction.x) > abs(direction.y):  
		if direction.x > 0: 
			if is_combo:
				$Sword.play("bossSwordCombo")
			else:
				$Sword.play("bossSword")
			$AttackHitbox.rotation = 0
			$Sword.flip_h = false
		else:  
			if is_combo:
				$Sword.play("bossSwordCombo")
			else:
				$Sword.play("bossSword")
			$AttackHitbox.rotation = 0  
			$Sword.flip_h = true
	else:  
		if direction.y < 0:
			if is_combo:
				$Sword.play("bossSwordComboUp")
			else:
				$Sword.play("bossSwordUp")
			$AttackHitbox.rotation = deg_to_rad(-90)
			$Sword.flip_h = false
		else:  
			if is_combo:
				$Sword.play("bossSwordComboDown")
			else:
				$Sword.play("bossSwordDown")
			$AttackHitbox.rotation = deg_to_rad(90)
			$Sword.flip_h = false

func activate_hitbox():
	$AttackHitbox.get_node("CollisionShape2D").disabled = false

func reset_combo():
	$Sword.rotation = 0
	combo_stage = 0
	combo_pending = false
	combo_timer = 0.0

func reset_attack():
	attacking = false
	combo_pending = false
	$AttackHitbox.get_node("CollisionShape2D").disabled = true
	reset_combo()
	$Sword.play("Idle")
