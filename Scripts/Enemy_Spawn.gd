extends Node2D

func _ready():
	pass

func spawn_enemy():
	var new_enemy = preload("res://Scenes/enemy.tscn").instantiate()
	new_enemy.player = get_node("/root/Game/Player")
	%SpawnPathFollow.progress_ratio = randf()
	new_enemy.global_position = %SpawnPathFollow.global_position
	add_child(new_enemy)
	


func _on_timer_timeout() -> void:
	spawn_enemy()
