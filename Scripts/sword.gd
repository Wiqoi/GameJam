extends AnimatedSprite2D

var target_position: Vector2
var move_speed: float = 100

func _process(delta):
	if target_position!= null:
		var direction = (target_position - global_position).normalized()
		global_position += direction * move_speed * delta
