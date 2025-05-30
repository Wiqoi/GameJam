extends Control

func _on_button_pressed() -> void:
	Global.playerMaxHP += 1
	Global.playerHP = Global.playerMaxHP
	Global.playerSkill = Global.playerMaxHP
	Global.playerDmg += 1
	%HealthBar1.texture = load("res://Assets/OurAssets/UI/Health2.png")
	%HealthBar2.texture = load("res://Assets/OurAssets/UI/Health2.png")
	%HealthBar3.texture = load("res://Assets/OurAssets/UI/Health2.png")
	%HealthBar4.texture = load("res://Assets/OurAssets/UI/Health2.png")
	%HealthBar5.texture = load("res://Assets/OurAssets/UI/Health2.png")
	%HealthBar6.texture = load("res://Assets/OurAssets/UI/Health2.png")
	%HealthBar7.texture = load("res://Assets/OurAssets/UI/Health2.png")
	%HealthBar8.texture = load("res://Assets/OurAssets/UI/Health2.png")
	%HealthBar9.texture = load("res://Assets/OurAssets/UI/Health2.png")
	%HealthBar10.texture = load("res://Assets/OurAssets/UI/Health2.png")
	$Button.visible = false
	$Button2.visible = false
	Global.betweenPhases = false

func _on_button_2_pressed() -> void:
	Global.currentPlayerAbility = 0
	$Button.visible = false
	$Button2.visible = false
	Global.betweenPhases = false
