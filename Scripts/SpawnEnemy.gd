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
		
func spawn_enemy4():
	var new_morph = preload("res://Scenes/Enemies/morph.tscn").instantiate()
	new_morph.player = get_node("/root/Game/Player")
	%SpawnPathFollow.progress_ratio = randf()
	new_morph.global_position = %SpawnPathFollow.global_position
	add_child(new_morph)
	
func spawn_enemy5():
	var new_slime = preload("res://Scenes/Enemies/slime.tscn").instantiate()
	var new_demon = preload("res://Scenes/Enemies/demon.tscn").instantiate()
	var new_morph = preload("res://Scenes/Enemies/morph.tscn").instantiate()
	new_morph.player = get_node("/root/Game/Player")
	new_slime.player = get_node("/root/Game/Player")
	new_demon.player = get_node("/root/Game/Player")
	%SpawnPathFollow.progress_ratio = randf()
	randomEnemy = randf()
	if randomEnemy > 0.66:
		new_slime.global_position = %SpawnPathFollow.global_position
		add_child(new_slime)
	elif randomEnemy > 0.33:
		new_demon.global_position = %SpawnPathFollow.global_position
		add_child(new_demon)
	else:
		new_morph.global_position = %SpawnPathFollow.global_position
		add_child(new_morph)
	
func _on_timer_timeout() -> void:
	timeCount += 1

func _on_spawn_enemy_timer_timeout() -> void:
	if timeCount < 30:
		spawn_enemy2()
	elif 50 < timeCount and timeCount < 80:
		spawn_enemy2()
	elif timeCount > 90 and timeCount < 120:
		spawn_enemy3()
	elif timeCount > 135 and timeCount < 165:
		spawn_enemy4()
	elif timeCount > 180 and timeCount < 210:
		spawn_enemy5()
