extends ColorRect

func _ready():
	visible = false
	modulate = Color(1,1,1,0)
	

func screen_out():
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	visible = false

func screen_in():
	visible = true
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _on_Button_pressed():
	screen_out()


func _on_ScreenIn_timeout():
	screen_in()
	GameDataManager.game_data["first_run"] = false
	GameDataManager.save_game()
