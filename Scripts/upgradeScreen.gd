extends Control

func _on_button_pressed() -> void:
	Global.playerMaxHP += 1
	Global.playerHP = Global.playerMaxHP
	Global.playerSkill = Global.playerMaxSkill
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
	%Ability1.texture = load("res://Assets/OurAssets/UI/Ability1.png")
	%Ability2.texture = load("res://Assets/OurAssets/UI/Ability1.png")
	%Ability3.texture = load("res://Assets/OurAssets/UI/Ability1.png")
	if Global.currentPhase == 6:
		%HealthBar1.visible = true
		%HealthBar2.visible = true
		%HealthBar3.visible = true
		%HealthBar4.visible = true
		%HealthBar5.visible = true
		%HealthBar6.visible = true
		%HealthBar7.visible = true
		%HealthBar8.visible = true
		%HealthBar9.visible = true
		%HealthBar10.visible = true
	visible = false
	Global.betweenPhases = false

func _on_button_2_pressed() -> void:
	Global.currentPlayerAbility = 0
	visible = false
