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
	
	if Global.playerMaxHP == 0:
		$HealthBar1.visible = false
	if Global.playerMaxHP == 1:
		$HealthBar1.visible = true
		$HealthBar2.visible = false
	if Global.playerMaxHP == 2:
		$HealthBar2.visible = true
		$HealthBar3.visible = false
	if Global.playerMaxHP == 3:
		$HealthBar3.visible = true
		$HealthBar4.visible = false
	if Global.playerMaxHP == 4:
		$HealthBar4.visible = true
		$HealthBar5.visible = false
	if Global.playerMaxHP == 5:
		$HealthBar5.visible = true
		$HealthBar6.visible = false
	if Global.playerMaxHP == 6:
		$HealthBar6.visible = true
		$HealthBar7.visible = false
	if Global.playerMaxHP == 7:
		$HealthBar7.visible = true
		$HealthBar8.visible = false
	if Global.playerMaxHP == 8:
		$HealthBar8.visible = true
		$HealthBar9.visible = false
	if Global.playerMaxHP == 9:
		$HealthBar9.visible = true
		$HealthBar10.visible = false
	if Global.playerMaxHP == 10:
		$HealthBar10.visible = true
		
	if Global.playerHP == 0:
		$HealthBar1.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 1:
		$HealthBar1.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$HealthBar2.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 2:
		$HealthBar2.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$HealthBar3.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 3:
		$HealthBar3.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$HealthBar4.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 4:
		$HealthBar4.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$HealthBar5.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 5:
		$HealthBar5.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$HealthBar6.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 6:
		$HealthBar6.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$HealthBar7.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 7:
		$HealthBar7.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$HealthBar8.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 8:
		$HealthBar8.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$HealthBar9.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 9:
		$HealthBar9.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$HealthBar10.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.playerHP == 10:
		$HealthBar10.texture = load("res://Assets/OurAssets/UI/Health2.png")
		
		
	if Global.bossHealth == 0:
		$Boss/Health/HealthBar1.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 1:
		$Boss/Health/HealthBar1.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$Boss/Health/HealthBar2.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 2:
		$Boss/Health/HealthBar2.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$Boss/Health/HealthBar3.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 3:
		$Boss/Health/HealthBar3.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$Boss/Health/HealthBar4.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 4:
		$Boss/Health/HealthBar4.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$Boss/Health/HealthBar5.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 5:
		$Boss/Health/HealthBar5.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$Boss/Health/HealthBar6.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 6:
		$Boss/Health/HealthBar6.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$Boss/Health/HealthBar7.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 7:
		$Boss/Health/HealthBar7.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$Boss/Health/HealthBar8.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 8:
		$Boss/Health/HealthBar8.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$Boss/Health/HealthBar9.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 9:
		$Boss/Health/HealthBar9.texture = load("res://Assets/OurAssets/UI/Health2.png")
		$Boss/Health/HealthBar10.texture = load("res://Assets/OurAssets/UI/Health3.png")
	if Global.bossHealth == 10:
		$Boss/Health/HealthBar10.texture = load("res://Assets/OurAssets/UI/Health2.png")
		
		
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
