extends Control

func _process(delta: float) -> void:
	if Global.playerHP == 4:
		$HealthBar5.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 3:
		$HealthBar4.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 2:
		$HealthBar3.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 1:
		$HealthBar2.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 0:
		$HealthBar1.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerSkill == 2:
		$Ability3.texture = load("res://Assets/OurAssets/UI/Ability0.png")
	if Global.playerSkill == 1:
		$Ability2.texture = load("res://Assets/OurAssets/UI/Ability0.png")
	if Global.playerSkill == 0:
		$Ability1.texture = load("res://Assets/OurAssets/UI/Ability0.png")
