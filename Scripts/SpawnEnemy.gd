extends Node2D

var randomEnemy
var waveNum : int = 0
var timeCount : int = 0

func _ready():
	pass

func spawn_enemy1():
	var new_slime = preload("res://Scenes/Enemies/slime.tscn").instantiate()
	new_slime.player = get_node("/root/Game/Player")
	%SpawnPathFollow.progress_ratio = randf()
	new_slime.global_position = %SpawnPathFollow.global_position
	add_child(new_slime)
		
func spawn_enemy2():
	var new_demon = preload("res://Scenes/Enemies/demon.tscn").instantiate()
	new_demon.player = get_node("/root/Game/Player")
	%SpawnPathFollow.progress_ratio = randf()
	new_demon.global_position = %SpawnPathFollow.global_position
	add_child(new_demon)
		
func spawn_enemy3():
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
	timeCount += 1


func _on_spawn_enemy_timer_timeout() -> void:
	if timeCount < 30:
		spawn_enemy1()
	elif 50 < timeCount and timeCount < 80:
		spawn_enemy2()
	elif timeCount > 100:
		spawn_enemy3()
