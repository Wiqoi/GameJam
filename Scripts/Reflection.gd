extends Node2D

var reflection
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	reflection = $Reflection


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.playerCurrentAnim == 0:
		$Reflection.play("Idle")
	if Global.playerCurrentAnim == 1:
		$Reflection.play("Walking")
		$Reflection.flip_h = false
	if Global.playerCurrentAnim == 2:
		$Reflection.play("Walking")
		$Reflection.flip_h = true
	if Global.playerCurrentAnim == 3:
		$Reflection.play("WalkingDown")
	if Global.playerCurrentAnim == 4:
		$Reflection.play("WalkingUp")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerCollision"):
		reflection.visible = true
		set_physics_process(true)
		player = area
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("PlayerCollision"):
		reflection.visible = true
		set_physics_process(false)
		player = null
		
func _physics_process(delta: float) -> void:
	reflection.set_global_position(Vector2(player.global_position.x, player.global_position.y + 23))
	
