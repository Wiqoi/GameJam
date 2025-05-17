extends CharacterBody2D

@export var movement_speed : float = 105
@export var deceleration : float = 1000
@export var cursor_distance : float = 25.0
@export var cursor_size : float = 2.0
@export var smooth_rotation : float = 0.4
@export var line_width : float = 1.2
@export var attacking = false
@export var attack_force : float = 80.0     # 减小攻击推力
@export var attack_duration : float = 0.2  # 攻击持续时间

var enemy_in_attack_range = false
var hp = 3
var player_alive = true
var attack_direction = Vector2.RIGHT      # 记录攻击方向
var attack_timer = 0.0                    # 攻击计时器
var pre_attack_direction = Vector2.ZERO   # 记录攻击前的移动方向

var character_direction : Vector2
var cursor_polygon : Polygon2D
var cursor_outline : Line2D

func _ready():
	create_cursor()

func _process(delta):
	if Input.is_action_just_pressed("Attack") and not attacking:
		attack()
	
	# 处理攻击计时器
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attacking = false
			# 恢复攻击前的移动方向
			character_direction = pre_attack_direction

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

func attack():
	attacking = true
	attack_timer = attack_duration
	pre_attack_direction = character_direction  # 保存攻击前的移动方向
	
	# 获取光标方向并确定攻击动画
	var mouse_position = get_global_mouse_position()
	attack_direction = (mouse_position - global_position).normalized()
	
	# 确定主要攻击方向
	if abs(attack_direction.x) > abs(attack_direction.y):
		if attack_direction.x > 0:
			$Sprite.play("Attack")  # 向右攻击
			$Sprite.flip_h = false
		else:
			$Sprite.play("Attack")  # 向左攻击
			$Sprite.flip_h = true
	else:
		if attack_direction.y < 0:
			$Sprite.play("AttackUp")  # 向上攻击
		else:
			$Sprite.play("AttackDown")  # 向下攻击

func _physics_process(delta):
	if not attacking:
		# 常规移动控制
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
			elif $Sprite.animation == "WalkingDown" or $Sprite.animation == "Walking":
				$Sprite.animation = "IdleDown"
	else:
		# 攻击时的轻微移动
		velocity = attack_direction * attack_force
	
	update_cursor()
	move_and_slide()

func update_cursor():
	if cursor_polygon and cursor_outline:
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		
		var cursor_pos = global_position + direction * cursor_distance
		cursor_polygon.global_position = cursor_pos
		cursor_outline.global_position = cursor_pos
		
		var target_angle = direction.angle() + PI/2
		cursor_polygon.rotation = target_angle
		cursor_outline.rotation = target_angle

func _on_player_hurt_box_area_entered(area: Area2D) -> void:
	pass # 处理受伤逻辑

func _on_player_hurt_box_area_exited(area: Area2D) -> void:
	pass # 处理受伤逻辑    
