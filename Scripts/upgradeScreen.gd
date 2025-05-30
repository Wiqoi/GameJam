extends Control

func _on_button_pressed() -> void:
	Global.playerMaxHP += 1
	Global.playerHP += 1
	Global.playerDmg += 1
	$Button.visible = false
	$Button2.visible = false
	Global.betweenPhases = false

func _on_button_2_pressed() -> void:
	Global.currentPlayerAbility = 0
	$Button.visible = false
	$Button2.visible = false
	Global.betweenPhases = false
