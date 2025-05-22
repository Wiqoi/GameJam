extends CharacterBody2D

var player: CharacterBody2D
var health: float = 4.0
var speed: float = 50.0
var is_jumping1: bool = false
var is_jumping2: bool = false
var dying: bool = false
var bleeding: bool = false
var pushed: bool = false
var frame_counter2 : int = 0
var freezed : bool = false
var hurt_timer: int = 0
var is_hurt : bool = false

var offset: Vector2 = Vector2(randf_range(-45, 45), randf_range(-45, 45))
var limit: int = 150
var frame_counter: int = 0
var jump_cooldown: int = 150
var jump_cooldown_timer: int = 0

var hitbox1: CollisionShape2D
var hitbox2: CollisionShape2D

func _ready() -> void:
	if !player:
		player = %Player 
	add_to_group("enemies")
	hitbox1 = %HitCollisionMorph
	hitbox2 = %HitCollisionMorph2
	hitbox1.disabled = true
	hitbox2.disabled = true
	$HitboxMorph.add_to_group("EnemyHitbox")
	%HurtCollisionMorph.disabled = false

func _physics_process(_delta: float) -> void:
	if not player or dying:
		return

	var direction = (player.global_position - global_position + offset).normalized()
	var separation = get_separation_force()
	
	if is_hurt:
		hurt_timer -= 1
		if hurt_timer <= 0:
			is_hurt = false
		velocity = Vector2.ZERO
	elif freezed:
		frame_counter2 += 1
		if frame_counter2 > 90:
			freezed = false
			frame_counter2 = 0
	elif pushed:
			is_jumping1 = false
			is_jumping2 = false
			var dMouse = (get_global_mouse_position() - global_position).normalized()
			if dMouse.length() <= 100:
				velocity = dMouse * speed
			else:
				pushed = false
	elif is_jumping1:
		handle_attack1(direction)
	elif is_jumping2:
		handle_attack2(direction)
	else:
		velocity = (direction + separation * 20).normalized() * speed
		hitbox1.disabled = true
		hitbox2.disabled = true
		$MorphSprite.animation = "Walking"

		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < 60 and jump_cooldown_timer <= 0:
			start_jump()

		if distance_to_player < 80:
			limit = 0
		elif distance_to_player < 151:
			limit = 80
		else:
			limit = 150
			
		$MorphSprite.flip_h = direction.x < 0
	
		if direction.x < 0:
			%HitCollisionMorph.position.x = -30
			%HitCollisionMorph2.position.x = -43.5
		else:
			%HitCollisionMorph.position.x = 30
			%HitCollisionMorph2.position.x = 43.5
		
	if jump_cooldown_timer > 0:
		jump_cooldown_timer -= 1

	frame_counter += 1
	if frame_counter % 60 == 0:
		frame_counter = 0
		update_offset()

	move_and_slide()

func start_jump() -> void:
	var randomAttack = randf()
	if randomAttack >= 0.5:
		is_jumping1 = true
		$MorphSprite.animation = "Attack1"
	else:
		is_jumping2 = true
		$MorphSprite.animation = "Attack2"

func handle_attack1(_direction: Vector2) -> void:
	velocity = Vector2.ZERO
	
	var frame = $MorphSprite.frame

	match frame:
		2, 3, 4, 5:
			hitbox1.disabled = false
		7:
			is_jumping1 = false
			jump_cooldown_timer = jump_cooldown
			hitbox1.disabled = true
			$MorphSprite.animation = "Walking"
		_:
			hitbox1.disabled = true

func handle_attack2(_direction: Vector2) -> void:
	velocity = Vector2.ZERO

	var frame = $MorphSprite.frame

	match frame:
		2, 3, 4:
			hitbox2.disabled = false
		5:
			is_jumping2 = false
			jump_cooldown_timer = jump_cooldown + 60
			hitbox2.disabled = true
			$MorphSprite.animation = "Walking"
		_:
			hitbox2.disabled = true

		

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
	%HitCollisionMorph.disabled = true
	%HitCollisionMorph2.disabled = true
	%HurtCollisionMorph.disabled = true
	$CollisionShape2D.disabled = true
	$MorphSprite.play("Die")

func _on_hurt_box_morph_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerAttack"):
		health -= Global.playerDmg
		if bleeding:
			health -= 1
			bleeding = false
			
		if health <= 0:
			call_deferred("die")
		else:
			$MorphSprite.animation = "Hurt"
			is_hurt = true
			hurt_timer = 15
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
			$MorphSprite.animation = "Hurt"
			is_hurt = true
			hurt_timer = 15
	elif area.is_in_group("FreezeTimer"):
		freezed = true

func _on_morph_sprite_animation_finished() -> void:
	if $MorphSprite.animation == "Death":
		queue_free()
