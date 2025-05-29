extends Node2D

@export var follow_speed: float = 80.0
@export var stop_distance: float = 10.0
@export var targ_dist: float = 15.0
@export var attack_duration: float = 0.8
@export var combo_window: float = 0.2
@export var hitbox_delay: float = 0.33
@export var attack_range: float = 30.0  # 新增：攻击范围参数

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
	position = Vector2(100, 100)
	
	$AttackHitbox.add_to_group("EnemyHitbox")
	$AttackHitbox.get_node("CollisionShape2D").disabled = true  # 初始禁用碰撞体

func _physics_process(delta):
	playerBossDistance = (player.global_position - boss.global_position)
	
	# 计算围绕Boss的目标位置
	if playerBossDistance.length() > 0:
		target_position = boss.global_position + playerBossDistance.normalized() * targ_dist
	else:
		target_position = boss.global_position + Vector2.RIGHT * targ_dist

	# 移动剑到目标位置
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

# 攻击逻辑处理
func _process(delta: float) -> void:
	# 计算与玩家的距离（使用剑的位置）
	var distance_to_player = (position - player.global_position).length()
	
	# 攻击状态管理
	if not attacking and distance_to_player < attack_range:
		# 玩家在攻击范围内，开始攻击
		attack()
	elif attacking and distance_to_player >= attack_range * 1.2:  # 放宽退出攻击的条件
		# 玩家离开攻击范围，停止攻击
		reset_attack()

	# 攻击计时器处理
	if attacking:
		# 更新攻击计时器
		attack_timer -= delta
		
		if attack_timer <= 0:
			# 攻击结束
			attacking = false
			$AttackHitbox.get_node("CollisionShape2D").disabled = true
			
			if combo_pending:
				execute_combo()
			else:
				reset_combo()
				$Sword.play("Idle")
		else:
			# 攻击进行中，处理碰撞体激活
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
	
	# 计算攻击方向（朝向玩家）
	attack_direction = (player.global_position - global_position).normalized()
	
	# 播放基础攻击动画
	perform_base_attack()
	
	# 重置碰撞体状态
	hitbox_timer = 0.0
	hitbox_activated = false
	$AttackHitbox.get_node("CollisionShape2D").disabled = true

func execute_combo():
	combo_pending = false
	attacking = true
	attack_timer = attack_duration * 0.8
	combo_stage += 1
	
	# 计算攻击方向
	attack_direction = (player.global_position - global_position).normalized()

	# 重置碰撞体状态
	hitbox_timer = 0.0
	hitbox_activated = false
	$AttackHitbox.get_node("CollisionShape2D").disabled = true
	
	# 根据攻击方向设置动画和碰撞体旋转
	set_attack_animation(attack_direction, true)

func perform_base_attack():
	# 根据攻击方向设置动画和碰撞体旋转
	set_attack_animation(attack_direction, false)

# 辅助函数：设置攻击动画和碰撞体旋转
func set_attack_animation(direction: Vector2, is_combo: bool):
	if abs(direction.x) > abs(direction.y):  # 水平攻击
		if direction.x > 0:  # 向右
			if is_combo:
				$Sword.play("bossSwordCombo")
			else:
				$Sword.play("bossSword")
			$AttackHitbox.rotation = 0
			$Sword.flip_h = false
		else:  # 向左
			if is_combo:
				$Sword.play("bossSwordCombo")
			else:
				$Sword.play("bossSword")
			$AttackHitbox.rotation = 0  # 旋转改为0，使用flip_h控制方向
			$Sword.flip_h = true
	else:  # 垂直攻击
		if direction.y < 0:  # 向上
			if is_combo:
				$Sword.play("bossSwordComboUp")
			else:
				$Sword.play("bossSwordUp")
			$AttackHitbox.rotation = deg_to_rad(-90)
			$Sword.flip_h = false
		else:  # 向下
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
