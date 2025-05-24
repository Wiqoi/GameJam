extends Node2D

var reflection
var player
var sword
var swordreflection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	reflection = $Reflection
	swordreflection = $SwordReflection


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Player
	if Global.playerCurrentAnim == 0:
		$Reflection.play("Idle")
	if Global.playerCurrentAnim == 1:
		$Reflection.play("Walking")
		$Reflection.flip_h = true
	if Global.playerCurrentAnim == 2:
		$Reflection.play("Walking")
		$Reflection.flip_h = false
	if Global.playerCurrentAnim == 3:
		$Reflection.play("WalkingDown")
	if Global.playerCurrentAnim == 4:
		$Reflection.play("WalkingUp")
	if Global.playerCurrentAnim == 10:
		$Reflection.play("PlayerDeath")
	#Sword
	if Global.swordCurrentAnim == 0:
		$SwordReflection.play("Attack")
		$SwordReflection.flip_h = true
	if Global.swordCurrentAnim == 1:
		$SwordReflection.play("Attack")
		$SwordReflection.flip_h = false
	if Global.swordCurrentAnim == 2:
		$SwordReflection.play("AttackUp")
	if Global.swordCurrentAnim == 3:
		$SwordReflection.play("AttackDown")
	if Global.swordCurrentAnim == 4:
		$SwordReflection.play("AttackCombo")
		$SwordReflection.flip_h = false
	if Global.swordCurrentAnim == 5:
		$SwordReflection.play("AttackCombo")
		$SwordReflection.flip_h = false
	if Global.swordCurrentAnim == 6:
		$SwordReflection.play("AttackComboUp")
	if Global.swordCurrentAnim == 7:
		$SwordReflection.play("AttackComboDown")
	if Global.swordCurrentAnim == 8:
		$SwordReflection.play("Idle")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("SwordCollision"):
		print("yay")
		swordreflection.visible = true
		set_physics_process(true)
		sword = area
	if area.is_in_group("PlayerCollision"):
		print("yay1")
		reflection.visible = true
		set_physics_process(true)
		player = area
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("PlayerCollision"):
		reflection.visible = false
		player = null
	if area.is_in_group("SwordCollision"):
		swordreflection.visible = false
		sword = null
		
func _physics_process(delta: float) -> void:
	swordreflection.set_global_position(Vector2(sword.global_position.x, sword.global_position.y + 23))
	reflection.set_global_position(Vector2(player.global_position.x, player.global_position.y + 48))
	
