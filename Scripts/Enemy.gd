extends CharacterBody2D

var player: CharacterBody2D
var health : float = 4.0
var speed : float = 50.0
var speedJump : float = 200.0
var frame_counter1 : int = 0
var frame_counter2 : int = 0
var limit : int = 150
var isJumping : bool = false
var offset = Vector2(randf_range(-45, 45), randf_range(-45, 45))
var dying : bool = false
var jump_cooldown_frames = 90
var jump_cooldown_counter = 0

var hitbox : CollisionShape2D

func _ready() -> void:
	add_to_group("enemies")
	hitbox = $%HitboxCollision
	if $Hitbox:
		$Hitbox.add_to_group("EnemyHitbox")

func _physics_process(_delta: float) -> void:
	if player && not dying:
		var direction = (player.global_position - global_position + offset).normalized()
		var separation = get_separation_force()
		
		if isJumping and frame_counter2 >= 20 and frame_counter2 <= 40:
			velocity = (player.global_position - global_position).normalized() * speedJump
			frame_counter2 += 1
			hitbox.disabled = false
		elif frame_counter2 < 20 and isJumping:
			hitbox.disabled = true
			frame_counter2 += 1
			velocity = Vector2.ZERO
		else:
			velocity = (direction + separation * 20).normalized() * speed
			hitbox.disabled = true
		
		frame_counter1 += 1
		if frame_counter1 % 60 == 0:
			frame_counter1 = 0
			update_offset()
			
		var distToPlayer = (global_position - player.global_position).length()
		if isJumping:
			jumpToPlayer()
		elif distToPlayer < 41 and jump_cooldown_counter <= 0:
			jumpToPlayer()
		elif distToPlayer < 80:
			limit = 0
		elif distToPlayer < 151:
			limit = 80
		else:
			limit = 150
			
		move_and_slide()
		
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
	if count > 0:
		return force / count
	else:
		return Vector2.ZERO

func jumpToPlayer():
	isJumping = true
	if $EnemySprite.animation != "Jumping":
		$EnemySprite.animation = "Jumping"
	
	if frame_counter2 >= 35:
		isJumping = false
		$EnemySprite.scale = Vector2(1, 1)
		$EnemySprite.animation = "Walking"
		frame_counter2 = 0
		jump_cooldown_counter = jump_cooldown_frames
		frame_counter2 = 0
	elif frame_counter2 >= 20:
		$EnemySprite.scale = Vector2(1.5, 1.5)



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
