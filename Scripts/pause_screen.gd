extends Control

signal btn_pressed

var is_data_saved = false

func _ready():
	visible = false
	modulate = Color(1,1,1,0)
	yield(get_tree().create_timer(0.5),"timeout")
	GameDataManager.game_data["hammer_booster"]["state"] = "ACTIVE"
	GameDataManager.game_data["score"] = 0
	GameDataManager.game_data["current_bricks"] = {}
	GameDataManager.game_data["save_array"] = []
	GameDataManager.game_data["current_etap"] = 1
	GameDataManager.save_game()
	is_data_saved = true


func screen_in():
	visible = true
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _on_Button_pressed():
	if is_data_saved:
		emit_signal("btn_pressed")


func _on_ColorRect_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		modulate = Color(1,1,1,0)
	elif event.is_action_released("ui_touch") and visible:
		modulate = Color(1,1,1,1)

