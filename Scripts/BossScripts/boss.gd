extends CharacterBody2D


@export var speed : float = 50
@export var health: int = 30


func _ready() -> void:
	pass
	var boss = preload("res://Scenes/Boss/boss.tscn")

func _physics_process(delta: float) -> void:
	pass
	
	# Add the gravity.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
