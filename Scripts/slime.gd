extends CharacterBody2D

var player: CharacterBody2D
var health : float = 3.0
var speed : float = 30.0
var speedJump : float = 150.0
var offset = Vector2(randf_range(-45, 45), randf_range(-45, 45))
var limit : int = 150
var isJumping : bool = false
var dying : bool = false
var bleeding : bool = false
var pushed : bool = false
var freeze_counter : int = 0
var freezed : bool = false
var is_hurt : bool = false
var hurt_timer: int = 0

var jump_cooldown_frames = 210
var jump_cooldown_counter = 0

var frame_counter1 : int = 0
var hitbox : CollisionShape2D

func _ready() -> void:
	if !player:
		player = %Player 
	add_to_group("enemies")
	hitbox = %HitboxCollisionSlime
	if $HitboxSlime:
		$HitboxSlime.add_to_group("EnemyHitbox")
	var hurtbox = %SlimeHurtBox
	hurtbox.disabled = false

func _physics_process(_delta: float) -> void:
	if player && not dying:
		var direction = (player.global_position - global_position + offset).normalized()
		var separation = get_separation_force()
		if is_hurt:
			hurt_timer -= 1
			if hurt_timer <= 0:
				is_hurt = false
				return
				
			velocity = direction * 0
		elif freezed:
			freeze_counter -= 1
			if freeze_counter < 0:
				freezed = false
				
			velocity = direction * 0
		elif pushed:
			isJumping = false
			var dMouse = (get_global_mouse_position() - global_position).normalized()
			if dMouse.length() <= 100:
				velocity = dMouse * speed
			else:
				pushed = false
		elif isJumping:
			jumpToPlayer()
		else:
			%SlimeSprite.play("Walking")
			velocity = (direction + separation * 20).normalized() * speed
			hitbox.disabled = true
		
		frame_counter1 += 1
		if frame_counter1 % 60 == 0:
			frame_counter1 = 0
			update_offset()

		var distToPlayer = (global_position - player.global_position).length()
		if not isJumping and distToPlayer < 41 and jump_cooldown_counter <= 0 and not is_hurt:
			isJumping = true
			%SlimeSprite.animation = "Jumping"
			
		if jump_cooldown_counter > 0:
			jump_cooldown_counter -= 1

		if distToPlayer < 80:
			limit = 0
		elif distToPlayer < 151:
			limit = 80
		else:
			limit = 150

		move_and_slide()

func jumpToPlayer():
	var frame = %SlimeSprite.frame
	match frame:
		0:
			velocity = Vector2.ZERO
			hitbox.disabled = true
		1, 2, 3:
			velocity = (player.global_position - global_position).normalized() * speedJump
			hitbox.disabled = false
		4, 5, 6, 7, 8:
			velocity = Vector2.ZERO
			hitbox.disabled = true
			
	if frame == 8 and %SlimeSprite.frame == 8 and %SlimeSprite.frame == %SlimeSprite.sprite_frames.get_frame_count("Jumping") - 1:
		isJumping = false
		jump_cooldown_counter = jump_cooldown_frames
		%SlimeSprite.play("Walking")
		
	%SlimeSprite.flip_h = velocity.x < 0
	
func update_offset():
	offset = Vector2(randf_range(-limit, limit), randf_range(-limit, limit))

func get_separation_force() -> Vector2:
	var force = Vector2.ZERO
	var nearby_enemies = get_tree().get_nodes_in_group("enemies")
	var count = 0
	for other in nearby_enemies:
		if other != self:
			var offsetTotal = global_position - other.global_position
			var dist = offsetTotal.length()
			if dist < 50 and dist > 0:
				force += offsetTotal.normalized() / dist
				count += 1
	return force / count if count > 0 else Vector2.ZERO

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerAttack"):
		health -= Global.playerDmg
		if bleeding:
			health -= 1
			bleeding = false
			
		if health <= 0:
			call_deferred("die")
		else:
			%SlimeSprite.play("Hurt")
			is_hurt = true
			hurt_timer = 15
			jump_cooldown_counter = jump_cooldown_frames
			isJumping = false
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
			%SlimeSprite.play("Hurt")
			is_hurt = true
			hurt_timer = 15
			jump_cooldown_counter = jump_cooldown_frames + 100
			isJumping = false
	elif area.is_in_group("TimeFreeze"):
		freezed = true
		freeze_counter = 600
		
	

func die():
	dying = true
	%HitboxCollisionSlime.disabled = true
	%SlimeSprite.play("Death")

func _on_enemy_sprite_animation_finished() -> void:
	if %SlimeSprite.animation == "Death":
		Global.smthDying = true
		queue_free()
