extends Node2D

var randomEnemy

func _ready():
	pass

func spawn_enemy():
	var new_slime = preload("res://Scenes/Enemies/slime.tscn").instantiate()
	var new_demon = preload("res://Scenes/Enemies/demon.tscn").instantiate()
	new_slime.player = get_node("/root/Game/Player")
	new_demon.player = get_node("/root/Game/Player")
	%SpawnPathFollow.progress_ratio = randf()
	randomEnemy = randf()
	if randomEnemy > 0.5:
		new_slime.global_position = %SpawnPathFollow.global_position
		add_child(new_slime)
	else:
		new_demon.global_position = %SpawnPathFollow.global_position
		add_child(new_demon)
	

func _on_timer_timeout() -> void:
	spawn_enemy()
