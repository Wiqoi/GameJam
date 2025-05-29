extends Node2D

var randomEnemy
var waveNum : int = 0
var timeCount : int = 0
var phase1 : bool = false
var phase2 : bool = false
var phase3 : bool = false
var phase4 : bool = false
var phase5 : bool = false
var enemyCount : int = 0
func _ready():
	pass
		
	

func spawn_enemy1():
	var new_slime = preload("res://Scenes/Enemies/slime.tscn").instantiate()
	new_slime.player = get_node("/root/Game/Player")
	new_slime.add_to_group("Phase1_Enemy")
	%SpawnPathFollow.progress_ratio = randf()
	new_slime.global_position = %SpawnPathFollow.global_position
	add_child(new_slime)
		
func spawn_enemy2():
	var new_demon = preload("res://Scenes/Enemies/demon.tscn").instantiate()
	new_demon.add_to_group("Phase2_Enemy")
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
		new_slime.add_to_group("Phase3_Enemy")
		add_child(new_slime)
	else:
		new_demon.global_position = %SpawnPathFollow.global_position
		new_demon.add_to_group("Phase3_Enemy")
		add_child(new_demon)
		
func spawn_enemy4():
	var new_morph = preload("res://Scenes/Enemies/morph.tscn").instantiate()
	new_morph.player = get_node("/root/Game/Player")
	new_morph.add_to_group("Phase4_Enemy")
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
		new_slime.add_to_group("Phase5_Enemy")
		add_child(new_slime)
	elif randomEnemy > 0.33:
		new_demon.global_position = %SpawnPathFollow.global_position
		new_demon.add_to_group("Phase5_Enemy")
		add_child(new_demon)
	else:
		new_morph.global_position = %SpawnPathFollow.global_position
		new_morph.add_to_group("Phase5_Enemy")
		add_child(new_morph)
	
func _on_timer_timeout() -> void:
	timeCount += 1

func _on_spawn_enemy_timer_timeout() -> void:
	if Global.betweenPhases == true:
		pass
	elif Global.currentPhase == 1:
		if get_tree().get_nodes_in_group("Phase1_Enemy").size() == 0 and phase1:
			Global.currentPhase = 2
			Global.betweenPhases = true
			enemyCount = 0
		elif enemyCount < 20:
			enemyCount += 1
			spawn_enemy1()
			phase1 = true
	elif Global.currentPhase == 2:
		if get_tree().get_nodes_in_group("Phase2_Enemy").size() == 0:
			Global.currentPhase = 3
			Global.betweenPhases = true
			enemyCount = 0
		elif enemyCount < 20:
			enemyCount += 1
			spawn_enemy2()
			phase2 = true
	elif Global.currentPhase == 3:
		if get_tree().get_nodes_in_group("Phase3_Enemy").size() == 0:
			Global.currentPhase = 4
			Global.betweenPhases = true
			enemyCount = 0
		elif enemyCount < 20:
			enemyCount += 1
			spawn_enemy3()
			phase3 = true
	elif Global.currentPhase == 4:
		if get_tree().get_nodes_in_group("Phase4_Enemy").size() == 0:
			Global.currentPhase = 5
			Global.betweenPhases = true
			enemyCount = 0
		elif enemyCount < 20:
			enemyCount += 1
			spawn_enemy4()
			phase4 = true
	elif Global.currentPhase == 5:
		if get_tree().get_nodes_in_group("Phase5_Enemy").size() == 0:
			Global.currentPhase = 6
			Global.betweenPhases = true
			enemyCount = 0
		elif enemyCount < 20:
			enemyCount += 1
			spawn_enemy5()
			phase5 = true
