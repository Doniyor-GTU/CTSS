extends Node



func _on_Button_pressed():
	SoundManager.play_fixed_sound("placed")


func _on_pause_screen_ready():
	SoundManager.play_fixed_sound("game_over")
