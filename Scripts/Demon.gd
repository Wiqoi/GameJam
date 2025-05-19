extends CharacterBody2D

var player: CharacterBody2D
var health: float = 4.0
var speed: float = 75.0
var is_jumping: bool = false
var dying: bool = false

var offset: Vector2 = Vector2(randf_range(-45, 45), randf_range(-45, 45))
var limit: int = 150
var frame_counter: int = 0
var jump_frame_counter: int = 0
var jump_cooldown: int = 210
var jump_cooldown_timer: int = 0

var hitbox: CollisionShape2D

func _ready() -> void:
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

	if is_jumping:
		handle_jump(direction)
	else:
		velocity = (direction + separation * 20).normalized() * speed
		hitbox.disabled = true
		$DemonSprite.animation = "Walking"

		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < 31 and jump_cooldown_timer <= 0:
			start_jump()

		if distance_to_player < 80:
			limit = 0
		elif distance_to_player < 151:
			limit = 80
		else:
			limit = 150

	$DemonSprite.flip_h = direction.x < 0
	if jump_cooldown_timer > 0:
		jump_cooldown_timer -= 1

	frame_counter += 1
	if frame_counter % 60 == 0:
		frame_counter = 0
		update_offset()

	move_and_slide()

func start_jump() -> void:
	is_jumping = true
	jump_frame_counter = 0
	$DemonSprite.animation = "Attack"

func handle_jump(direction: Vector2) -> void:
	jump_frame_counter += 1

	if jump_frame_counter < 20:
		velocity = Vector2.ZERO
		hitbox.disabled = true
	elif jump_frame_counter <= 80:
		velocity = Vector2.ZERO
		hitbox.disabled = false
	else:
		is_jumping = false
		jump_frame_counter = 0
		jump_cooldown_timer = jump_cooldown
		velocity = Vector2.ZERO
		hitbox.disabled = true
		$DemonSprite.animation = "Walking"

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
	$DemonSprite.play("Death")

func _on_demon_sprite_animation_finished() -> void:
	if $DemonSprite.animation == "Death":
		queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerAttack"):
		health -= Global.playerDmg
		if health <= 0:
			die()
