extends Control

func _on_button_pressed() -> void:
	Global.playerMaxHP += 1
	Global.playerHP += 1
	Global.playerDmg += 1
	visible = false

func _on_button_2_pressed() -> void:
	Global.currentPlayerAbility = 0
	visible = false
