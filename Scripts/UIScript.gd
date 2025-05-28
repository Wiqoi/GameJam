extends Control

var xpTimer = 0
var xpDuration = 0.5
var Xping : bool = false

func _process(delta: float) -> void:
	
	if Global.betweenPhases == true:
		$UpgradeScreen.visible = true
	
	if Global.smthDying == true:
		$Advertisment2/ColorRect.visible = true
		$Advertisment2/RichTextLabel.visible = true
		Xping = true
	if Xping == true:
		xpTimer += delta
		print(xpTimer)
		if xpTimer >= xpDuration:
			Global.smthDying = false
			xpTimer = 0
			Xping = false
			$Advertisment2/RichTextLabel.visible = false
			$Advertisment2/ColorRect.visible = false
	
	if Global.playerHP == 4:
		$HealthBar5.texture = load("res://Assets/OurAssets/UI/Health3.png")
	elif Global.playerHP == 3:
		$HealthBar4.texture = load("res://Assets/OurAssets/UI/Health3.png")
	elif Global.playerHP == 2:
		$HealthBar3.texture = load("res://Assets/OurAssets/UI/Health3.png")
	elif Global.playerHP == 1:
		$HealthBar2.texture = load("res://Assets/OurAssets/UI/Health3.png")
	elif Global.playerHP == 0:
		$HealthBar1.texture = load("res://Assets/OurAssets/UI/Health3.png")
		
	if Global.playerSkill == 2:
		$Ability3.texture = load("res://Assets/OurAssets/UI/Ability0.png")
	elif Global.playerSkill == 1:
		$Ability2.texture = load("res://Assets/OurAssets/UI/Ability0.png")
	elif Global.playerSkill == 0:
		$Ability1.texture = load("res://Assets/OurAssets/UI/Ability0.png")
		
	if Global.currentPhase == 1:
		$RichTextLabel.clear()
		$RichTextLabel.add_text("Phase 1")
	elif Global.currentPhase == 2:
		$RichTextLabel.clear()
		$RichTextLabel.add_text("Phase 2")
	elif Global.currentPhase == 3:
		$RichTextLabel.clear()
		$RichTextLabel.add_text("Phase 3")
	elif Global.currentPhase == 4:
		$RichTextLabel.clear()
		$RichTextLabel.add_text("Phase 4")
	elif Global.currentPhase == 5:
		$RichTextLabel.clear()
		$RichTextLabel.add_text("Phase 5")
	elif Global.currentPhase == 6:
		$RichTextLabel.clear()
		$RichTextLabel.add_text("Bosh Time")
