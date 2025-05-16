extends CollisionShape2D

var radius = 8
var tween: Tween

func _ready():
	tween = create_tween()
	$CollisionShape2D.shape.radius = radius

func play_collision_animation():
	if tween.is_active():
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(self, "radius", 30, 3.0).set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(self, "radius", 8, 3.0).set_trans(Tween.TRANS_LINEAR)

func _process(delta):
	$CollisionShape2D.shape.radius = radius
