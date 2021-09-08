extends TextureRect

signal hammer_booster_pressed

var is_int_connected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$ErrorMessage.modulate = Color(1,1,1,0)
	$ErrorMessage.visible = false

func score_increase_effect(boolean : bool):
	if boolean:
		$Etap/AnimationPlayer.play("score_increase")
	else:
		$Etap/AnimationPlayer.play("ScoreIncreaseAnimation_other_themes")

func error_msg_show():
	if not is_int_connected:
		$ErrorMessage.visible = true
		$ErrorMessage/Tween.interpolate_property($ErrorMessage, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$ErrorMessage/Tween.start()
		$ErrorMessage/Timer.start()

func _on_Grid_hammer_booster_place(where):
	if where == "on_null":
		$Hammer_Button.pressed = false
	elif where == "on_shape":
		var current_turn = GameDataManager.game_data["current_etap"]
		GameDataManager.game_data["hammer_booster"]["first_used_turn"] = current_turn
		var first_pressed_turn = current_turn
		$Hammer_Button.pressed = false
		$Hammer_Button.state = $Hammer_Button.PROGRESSING
		GameDataManager.game_data["hammer_booster"]["state"] = "PROGRESSING"
		GameDataManager.save_game()
		$Hammer_Button.set_progress(first_pressed_turn, current_turn)
	elif where == "on_empty":
		var current_turn = GameDataManager.game_data["current_etap"]
		GameDataManager.game_data["hammer_booster"]["first_used_turn"] = current_turn
		var first_pressed_turn = current_turn
		$Hammer_Button.pressed = false
		$Hammer_Button.state = $Hammer_Button.PROGRESSING
		GameDataManager.game_data["hammer_booster"]["state"] = "PROGRESSING"
		GameDataManager.save_game()
		$Hammer_Button.set_progress(first_pressed_turn, current_turn)


func _on_Hammer_Button_btn_pressed():
	emit_signal("hammer_booster_pressed")


func _on_Timer_timeout():
	$ErrorMessage/Tween.interpolate_property($ErrorMessage, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$ErrorMessage/Tween.start()
	yield($ErrorMessage/Tween, "tween_all_completed")
	$ErrorMessage.visible = false


func _on_AdMob_banner_loaded():
	is_int_connected = true
