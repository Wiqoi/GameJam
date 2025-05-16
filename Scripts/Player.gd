extends CharacterBody2D

@export var movement_speed : float = 185
@export var deceleration : float = 1000
@export var cursor_distance : float = 25.0
@export var cursor_size : float = 2.0
@export var smooth_rotation : float = 0.4
@export var line_width : float = 1.2

var enemy_in_attack_range = false
var hp = 3
var player_alive = true

var character_direction : Vector2
var cursor_polygon : Polygon2D
var cursor_outline : Line2D

func _ready():
	create_cursor()

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

func _unhandled_key_input(event: "Attack") -> void:
	pass
	$PlayerAttack 


func _on_player_hurt_box_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_player_hurt_box_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
