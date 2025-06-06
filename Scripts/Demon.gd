extends CharacterBody2D

var player : CharacterBody2D
var health : float = 6.0
var speed : float = 80.0
var is_jumping : bool = false
var dying : bool = false
var bleeding : bool = false
var pushed : bool = false
var is_hurt : bool = false
var offset : Vector2 = Vector2(randf_range(-45, 45), randf_range(-45, 45))
var limit : int = 150
var frame_counter : int = 0

var jump_cooldown_frames : int = 210
var jump_cooldown_timer : int = 0

var freezed : bool = false
var hurt_timer: int = 0
var freeze_counter : int = 0

var hitbox: CollisionShape2D

func _ready() -> void:
	if !player:
		player = %Player 
	add_to_group("enemies")
	hitbox = %HitboxCollisionDemon
	hitbox.disabled = true
	%HitboxDemon.add_to_group("EnemyHitbox")
	%HurtboxCollisionDemon.disabled = false

func _physics_process(_delta: float) -> void:
	if not player or dying:
		return

	var direction = (player.global_position - global_position + offset).normalized()
	var separation = get_separation_force()
	
	if is_hurt:
		hurt_timer -= 1
		if hurt_timer <= 0:
			is_hurt = false
		velocity = direction * 0
	elif freezed:
		freeze_counter -= 1
		if freeze_counter < 0:
			freezed = false
		velocity = direction * 0
	elif pushed:
			is_jumping = false
			var dMouse = (get_global_mouse_position() - global_position).normalized()
			if dMouse.lengtha() <= 100:
				velocity = dMouse * speed
			else:
				pushed = false
	elif is_jumping:
		handle_jump(direction)
		
	if not freezed and not pushed and not is_jumping and not is_hurt:
		velocity = (direction + separation * 20).normalized() * speed
		hitbox.disabled = true
		%DemonSprite.play("Walking")

		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < 31 and jump_cooldown_timer <= 0:
			start_jump()
			
		if jump_cooldown_timer > 0:
			jump_cooldown_timer -= 1

		if distance_to_player < 80:
			limit = 0
		elif distance_to_player < 151:
			limit = 80
		else:
			limit = 150

	$DemonSprite.flip_h = direction.x < 0
	
	if direction.x < 0:
		$DemonSprite.position.x = -21.77
	else:
		$DemonSprite.position.x = 21.77

	frame_counter += 1
	if frame_counter % 60 == 0:
		frame_counter = 0
		update_offset()

	move_and_slide()

func start_jump() -> void:
	is_jumping = true
	$DemonSprite.animation = "Attack"

func handle_jump(_direction: Vector2) -> void:
	velocity = Vector2.ZERO

	var frame = $DemonSprite.frame

	match frame:
		1, 2, 3, 6, 7, 8:
			hitbox.disabled = false
		11:
			is_jumping = false
			jump_cooldown_timer = jump_cooldown_frames
			hitbox.disabled = true
			$DemonSprite.animation = "Walking"
		_:
			hitbox.disabled = true


func update_offset() -> void:
	offset = Vector2(randf_range(-limit, limit), randf_range(-limit, limit))

func get_separation_force() -> Vector2:
	var force = Vector2.ZERO
	var nearby_enemies = get_tree().get_nodes_in_group("enemies")
	var count = 0
	for other in nearby_enemies:
		if other != self:
			var diff = global_position - other.global_position
			var dist = diff.length()
			if dist < 50 and dist > 0:
				force += diff.normalized() / dist
				count += 1
	return force / count if count > 0 else Vector2.ZERO

func die() -> void:
	dying = true
	%HitboxCollisionDemon.disabled = true
	$DemonSprite.play("Death")

func _on_demon_sprite_animation_finished() -> void:
	if $DemonSprite.animation == "Death":
		Global.smthDying = true
		queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerAttack"):
		health -= Global.playerDmg
		if bleeding:
			health -= 1
			bleeding = false
			
		if health <= 0:
			call_deferred("die")
		else:
			%DemonSprite.play("Hurt")
			is_hurt = true
			hurt_timer = 15
			jump_cooldown_timer = jump_cooldown_frames + 100
			is_jumping = false
	elif area.is_in_group("Bleed"):
		bleeding = true
	elif area.is_in_group("PushAway"):
		pushed = true
	elif area.is_in_group("AbilityMain"):
		health -= 2
		if bleeding:
			health -= 1
			bleeding = false
			
		if health <= 0:
			call_deferred("die")
		else:
			%DemonSprite.play("Hurt")
			is_hurt = true
			hurt_timer = 15
			jump_cooldown_timer = jump_cooldown_frames + 100
			is_jumping = false
	elif area.is_in_group("TimeFreeze"):
		freezed = true
		freeze_counter = 600
