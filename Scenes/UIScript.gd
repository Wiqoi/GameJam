extends Control

func _process(delta: float) -> void:
	if Global.playerHP == 4:
		$HealthBar5.visible = false
	if Global.playerHP == 3:
		$HealthBar4.visible = false
	if Global.playerHP == 2:
		$HealthBar3.visible = false
	if Global.playerHP == 1:
		$HealthBar2.visible = false
	if Global.playerHP == 0:
		$HealthBar1.visible = false
