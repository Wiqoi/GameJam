extends Node2D


func _ready() -> void:
	spawn_boss()

func _process(delta: float) -> void:
	pass

func spawn_boss():
	var boss = preload("res://Scenes/Boss/boss.tscn").instantiate()
	boss.player = get_node("/root/BossScene/Player")
	add_child(boss)
