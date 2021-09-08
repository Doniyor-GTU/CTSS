extends Control


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/MainScreen.tscn")

func _on_Button_0_pressed():
	SettingsManager._settings["display"]["theme"] = 0
	SettingsManager.save_settings()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainScreen.tscn")


func _on_Button_1_pressed():
	SettingsManager._settings["display"]["theme"] = 1
	SettingsManager.save_settings()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainScreen.tscn")


func _on_Button_2_pressed():
	SettingsManager._settings["display"]["theme"] = 2
	SettingsManager.save_settings()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainScreen.tscn")


func _on_Button_3_pressed():
	SettingsManager._settings["display"]["theme"] = 3
	SettingsManager.save_settings()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainScreen.tscn")
