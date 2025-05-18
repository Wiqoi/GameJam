extends CharacterBody2D

@export var movement_speed : float = 105
@export var deceleration : float = 1000
@export var cursor_distance : float = 25.0
@export var cursor_size : float = 2.0
@export var smooth_rotation : float = 0.4
@export var line_width : float = 1.2

@export var dash_speed: float = 300.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0 

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.RIGHT

@export var footstep_scene: PackedScene = preload("res://Scenes/Player/playerFootsteps.tscn") 
@export var footstep_interval: float = 0.5

var footstep_timer: float = 0.0
var is_moving: bool = false

var hp = 5
var player_alive = true
var damaged: bool = false
var is_invincible: bool = false
var damage_NoMove_Duration: float = 0.5
var damage_NoMove_Timer: float = 0.0
var invincibility_duration: float = 2.0
var invincibility_timer: float = 0.0

var character_direction : Vector2
var cursor_polygon : Polygon2D
var cursor_outline : Line2D

var sword : AnimatedSprite2D

func _ready():
	create_cursor()
	footstep_timer = footstep_interval
	Global.cursorPos = Vector2.ZERO

func _process(delta):
	handle_dash_input()

func handle_dash_input():
	if Input.is_action_just_pressed("Dash") and !is_dashing and dash_cooldown_timer <= 0:
		dash_direction = get_dash_direction()
		start_dash()

func get_dash_direction():
	var mouse_pos = get_global_mouse_position()
	return (mouse_pos - global_position).normalized() if mouse_pos != Vector2.ZERO else character_direction.normalized()

func start_dash():
	is_dashing = true
	dash_timer = dash_duration
	dash_cooldown_timer = dash_cooldown

	var mouse_pos = get_global_mouse_position()
	var dash_direction = (mouse_pos - global_position).normalized()
	
	if $Sprite:
		$Sprite.play("Dash")
		$Sprite.flip_h = dash_direction.x < 0
	
	character_direction = Vector2.ZERO
	velocity = Vector2.ZERO

func create_cursor():
	cursor_polygon = Polygon2D.new()
	add_child(cursor_polygon)
	
	var points = PackedVector2Array()
	points.append(Vector2(0, -cursor_size * 1.5))
	points.append(Vector2(-cursor_size, cursor_size))
	points.append(Vector2(cursor_size, cursor_size))
	cursor_polygon.polygon = points
	cursor_polygon.color = Color(0, 0, 0, 0)

	cursor_outline = Line2D.new()
	add_child(cursor_outline)
	
	cursor_outline.points = points
	cursor_outline.add_point(points[0])
	cursor_outline.default_color = Color.WHITE
	cursor_outline.width = line_width
	cursor_outline.z_index = 2

func _physics_process(delta):
	if is_invincible:
		$Invincible.visible = true
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			is_invincible = false
			$Invincible.visible = false
	if damaged:
		damage_NoMove_Timer += delta
		if damage_NoMove_Timer >= damage_NoMove_Duration:
			damaged = false
	is_moving = character_direction.length() > 0.1
	if is_moving:
		footstep_timer -= delta
		if footstep_timer <= 0:
			spawn_footstep()
			footstep_timer = footstep_interval
	else:
		footstep_timer = footstep_interval
	if not is_dashing:
		if dash_cooldown_timer > 0:
			dash_cooldown_timer -= delta
		if not damaged:
			character_direction.x = Input.get_axis("Player_Left", "Player_Right")
			character_direction.y = Input.get_axis("Player_Up", "Player_Down")
			
			character_direction = character_direction.normalized()
			
			if character_direction.x > 0:
				$Sprite.flip_h = false
			elif character_direction.x < 0:
				$Sprite.flip_h = true
			
			if character_direction:
				velocity = character_direction * movement_speed
				if abs(character_direction.y) > abs(character_direction.x):
					if character_direction.y < 0:
						if $Sprite.animation != "WalkingUp":
							$Sprite.animation = "WalkingUp"
					else:
						if $Sprite.animation != "WalkingDown":
							$Sprite.animation = "WalkingDown"
				else:
					if $Sprite.animation != "Walking":
						$Sprite.animation = "Walking"
			else:
				velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
				if $Sprite.animation == "WalkingUp":
					$Sprite.animation = "IdleUp"
				else:
					$Sprite.animation = "IdleDown"
		elif damaged:
			velocity = Vector2(0, 0)
	else:
		handle_dash_movement(delta)
	update_cursor()
	move_and_slide()

func handle_dash_movement(delta):
	dash_timer -= delta
	velocity = dash_direction * dash_speed
	
	if dash_timer <= 0:
		is_dashing = false
		velocity = Vector2.ZERO		
		character_direction = Vector2.ZERO
		dash_cooldown_timer = max(dash_cooldown_timer, dash_cooldown)

func _on_dash_animation_finished():
	if $Sprite.animation == "Dash":
		$Sprite.animation = "IdleDown"

func update_cursor():
	if cursor_polygon and cursor_outline:
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		
		var cursor_pos = global_position + direction * cursor_distance
		cursor_polygon.global_position = cursor_pos
		cursor_outline.global_position = cursor_pos
		Global.cursorPos = cursor_pos
		var target_angle = direction.angle() + PI/2
		cursor_polygon.rotation = target_angle
		cursor_outline.rotation = target_angle

func _on_player_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyHitbox"):
		take_damage()

func spawn_footstep():
	if footstep_scene:
		var footstep = footstep_scene.instantiate() as AnimatedSprite2D
		footstep.global_position = global_position + Vector2(-10, -30)
		if character_direction.x < 0:
			footstep.flip_h = true
			footstep.global_position = global_position + Vector2(10, -33)
		else:
			footstep.global_position = global_position + Vector2(-10, -33)
		
		get_tree().get_root().add_child(footstep)	
		footstep.play()
			
func take_damage() -> void:
	if !is_invincible and hp > 0:
		hp -= 1
		Global.playerHP -= 1
		is_invincible = true
		invincibility_timer = invincibility_duration
		damage_NoMove_Timer = 0
		damaged = true
		$Sprite.animation = "PlayerHit"
		if hp <= 0:
			die()
			
func die() -> void:
	$Sprite.play("PlayerDeath")
	damaged = true
	queue_free()
	get_tree().quit()
