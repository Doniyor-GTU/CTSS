extends Node

var sound_off_texture_0 = preload("res://Art/1_aa.png")
var sound_on_texture_0 = preload("res://Art/1_b.png")
var sound_off_texture_1 = preload("res://Art/2_bb.png")
var sound_on_texture_1 = preload("res://Art/2_b.png")
var sound_off_texture_2 = preload("res://Art/3_bb.png")
var sound_on_texture_2 = preload("res://Art/3_b.png")
var sound_off_texture_3 = preload("res://Art/4_bb.png")
var sound_on_texture_3 = preload("res://Art/4_b.png")

func _ready():
	set_theme()
	var max_etap = GameDataManager.game_data["max_etap"]
	var sound_on = SettingsManager._settings["audio"]["sounds_on"]
	set_max_etap(max_etap)
	set_sound_button_value(sound_on)
	$AdMob/StartLoadTimer.start()
	
	

func set_max_etap(val):
	$Theme_0/Skor/Score.text = str(val)
	$Theme_1/Skor/Score.text = str(val)
	$Theme_2/Skor/Score.text = str(val)
	$Theme_3/Skor/Score.text = str(val)
	
func set_sound_button_value(val):
	set_sound_btn_texture(sound_on_texture_0, sound_off_texture_0, $Theme_0/Skor/buttons/sound_button_0, val)
	set_sound_btn_texture(sound_on_texture_1, sound_off_texture_1, $Theme_1/Skor/Buttons/Sound_button_1, val)
	set_sound_btn_texture(sound_on_texture_2, sound_off_texture_2, $Theme_2/Skor/Buttons/Sound_button_2, val)
	set_sound_btn_texture(sound_on_texture_3, sound_off_texture_3, $Theme_3/Skor/Buttons/Sound_button_3, val)

func set_theme():
	var theme = SettingsManager._settings["display"]["theme"]
	if theme == 0:
		$Theme_0.visible = true
		$Theme_1.visible = false
		$Theme_2.visible = false
		$Theme_3.visible = false
	elif theme == 1:
		$Theme_0.visible = false
		$Theme_1.visible = true
		$Theme_2.visible = false
		$Theme_3.visible = false
	elif theme == 2:
		$Theme_0.visible = false
		$Theme_1.visible = false
		$Theme_2.visible = true
		$Theme_3.visible = false
	elif theme == 3:
		$Theme_0.visible = false
		$Theme_1.visible = false
		$Theme_2.visible = false
		$Theme_3.visible = true

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()


func set_sound_btn_texture(on_texture : Texture, of_texture : Texture, node, value : bool):
	if value != true:
		node.get("custom_styles/normal").set("texture", of_texture)
		node.get("custom_styles/hover").set("texture", of_texture)
		node.get("custom_styles/pressed").set("texture", of_texture)
	else:
		node.get("custom_styles/normal").set("texture", on_texture)
		node.get("custom_styles/hover").set("texture", on_texture)
		node.get("custom_styles/pressed").set("texture", on_texture)

func _on_Button_0_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	get_tree().change_scene_to(LoadScreens.Theme_0)
#	if GameDataManager.game_data["first_run"] == true:
#		get_tree().change_scene_to(LoadScreens.Theme_0_Tutorial)
#	else:
#		get_tree().change_scene_to(LoadScreens.Theme_0)
	
func _on_Button_1_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	get_tree().change_scene_to(LoadScreens.Theme_1)


func _on_Button_2_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	get_tree().change_scene_to(LoadScreens.Theme_2)


func _on_Button_3_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	get_tree().change_scene_to(LoadScreens.Theme_3)


func _on_Theme_button_2_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	get_tree().change_scene_to(LoadScreens.ThemeScreen)


func _on_Theme_button_1_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	get_tree().change_scene_to(LoadScreens.ThemeScreen)


func _on_themes_button_0_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	get_tree().change_scene_to(LoadScreens.ThemeScreen)


func _on_Theme_button_3_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	get_tree().change_scene_to(LoadScreens.ThemeScreen)


func _on_sound_button_0_pressed():
	var sound_on = SettingsManager._settings["audio"]["sounds_on"]
	sound_on = not sound_on
	SettingsManager._settings["audio"]["sounds_on"] = sound_on
	SettingsManager.save_settings()
	set_sound_btn_texture(sound_on_texture_0, sound_off_texture_0, $Theme_0/Skor/buttons/sound_button_0, sound_on)


func _on_Sound_button_1_pressed():
	var sound_on = SettingsManager._settings["audio"]["sounds_on"]
	sound_on = not sound_on
	SettingsManager._settings["audio"]["sounds_on"] = sound_on
	SettingsManager.save_settings()
	set_sound_btn_texture(sound_on_texture_1, sound_off_texture_1, $Theme_1/Skor/Buttons/Sound_button_1, sound_on)
	


func _on_Sound_button_2_pressed():
	var sound_on = SettingsManager._settings["audio"]["sounds_on"]
	sound_on = not sound_on
	SettingsManager._settings["audio"]["sounds_on"] = sound_on
	SettingsManager.save_settings()
	set_sound_btn_texture(sound_on_texture_2, sound_off_texture_2, $Theme_2/Skor/Buttons/Sound_button_2, sound_on)


func _on_Sound_button_3_pressed():
	var sound_on = SettingsManager._settings["audio"]["sounds_on"]
	sound_on = not sound_on
	SettingsManager._settings["audio"]["sounds_on"] = sound_on
	SettingsManager.save_settings()
	set_sound_btn_texture(sound_on_texture_3, sound_off_texture_3, $Theme_3/Skor/Buttons/Sound_button_3, sound_on)


func _on_star_button_0_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	OS.shell_open("https://play.google.com/store/apps/developer?id=Visima")


func _on_Star_button_1_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	OS.shell_open("https://play.google.com/store/apps/developer?id=Visima")


func _on_Rate_button_2_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	OS.shell_open("https://play.google.com/store/apps/developer?id=Visima")


func _on_Rate_button_3_pressed():
# warning-ignore:return_value_discarded
	$AdMob.hide_banner()
	OS.shell_open("https://play.google.com/store/apps/developer?id=Visima")


func _on_AdMob_banner_loaded():
	$AdMob.show_banner()


# warning-ignore:unused_argument
func _on_AdMob_banner_failed_to_load(error_code):
	$AdMob/AdLoadTimer.start()


func _on_AdLoadTimer_timeout():
	$AdMob.load_banner()


func _on_StartLoadTimer_timeout():
	$AdMob.load_banner()

