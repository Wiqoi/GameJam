extends Control

func _on_button_pressed() -> void:
	Global.playerHP += 1
	Global.playerDmg += 1

func _on_button_2_pressed() -> void:
	Global.currentPlayerAbility = 0
