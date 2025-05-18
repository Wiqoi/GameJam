extends CharacterBody2D

var player: CharacterBody2D
var health : float = 4.0
var speed : float = 50.0
var speedJump : float = 200.0
var offset = Vector2(randf_range(-45, 45), randf_range(-45, 45))
var limit : int = 150
var isJumping : bool = false
var dying : bool = false

var jump_frame_counter : int = 0
var jump_cooldown_frames = 210
var jump_cooldown_counter = 0

var frame_counter1 : int = 0
var hitbox : CollisionShape2D

func _ready() -> void:
	add_to_group("enemies")
	hitbox = %HitboxCollision
	if $Hitbox:
		$Hitbox.add_to_group("EnemyHitbox")
	var hurtbox = %EnemyHurtBox
	hurtbox.disabled = false

func _physics_process(_delta: float) -> void:
	if player && not dying:
		var direction = (player.global_position - global_position + offset).normalized()
		var separation = get_separation_force()

		if isJumping:
			jumpToPlayer()
		else:
			velocity = (direction + separation * 20).normalized() * speed
			hitbox.disabled = true

		frame_counter1 += 1
		if frame_counter1 % 60 == 0:
			frame_counter1 = 0
			update_offset()

		var distToPlayer = (global_position - player.global_position).length()
		if not isJumping and distToPlayer < 41 and jump_cooldown_counter <= 0:
			isJumping = true
			jump_frame_counter = 0
			$EnemySprite.animation = "Jumping"

		if distToPlayer < 80:
			limit = 0
		elif distToPlayer < 151:
			limit = 80
		else:
			limit = 150

		if jump_cooldown_counter > 0:
			jump_cooldown_counter -= 1

		move_and_slide()

func jumpToPlayer():
	if jump_frame_counter < 20:
		velocity = Vector2.ZERO
		hitbox.disabled = true
	elif jump_frame_counter <= 35:
		velocity = (player.global_position - global_position).normalized() * speedJump
		hitbox.disabled = false
	else:
		isJumping = false
		$EnemySprite.animation = "Walking"
		hitbox.disabled = true
		jump_cooldown_counter = jump_cooldown_frames
		jump_frame_counter = 0
		return

	jump_frame_counter += 1

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
		if health <= 0:
			die()

func die():
	dying = true
	$EnemySprite.play("Death")

func _on_enemy_sprite_animation_finished() -> void:
	if $EnemySprite.animation == "Death":
		queue_free()
