extends ColorRect

onready var continue_btn = $ContinueButton

func _ready():
	visible = false
	$Label.rect_scale = Vector2(0.5,0.5)
	modulate = Color(1,1,1,0)
	

func screen_in():
	visible = true 
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($Label, "rect_scale", Vector2(0.4,0.4), Vector2(1,1), 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	$finger.global_position = continue_btn.rect_global_position + Vector2(248,56)
	$finger/icon.rect_rotation = 0
	$finger.start_animation(0,0, "oneTap")


func _on_Grid_tutorial_end():
	screen_in()

