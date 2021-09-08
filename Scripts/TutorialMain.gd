extends Node

signal give_new_bricks


var game_over_screens = [
	preload("res://Scenes/game_over_screen_theme1.tscn"),
	preload("res://Scenes/game_over_screen_theme2.tscn"),
	preload("res://Scenes/game_over_screen_theme3.tscn")
]
var game_over_screen = preload("res://Scenes/game_over_screen.tscn")
var passed_bricks = 0
var etap = 1
var max_etap = 1
var rnd = RandomNumberGenerator.new()
onready var go_back_timer = get_node("../GoBackTimer")
onready var game_node = get_node("../")

func _ready():
	if GameDataManager.game_data["hammer_booster"]["state"] != "ACTIVE":
		GameDataManager.game_data["hammer_booster"]["state"] = "ACTIVE"
	set_game_over_screen()
	rnd.randomize()
	var left_bricks_count = 3
	if left_bricks_count != 0:
		passed_bricks = 3 - left_bricks_count
	etap = GameDataManager.game_data["current_etap"]
	max_etap = GameDataManager.game_data["max_etap"]
	set_etap(etap)
	set_max_etap(max_etap)



func set_game_over_screen():
	var theme = SettingsManager._settings["display"]["theme"]
	if theme == 1:
		game_over_screen = game_over_screens[0]
	elif theme == 2:
		game_over_screen = game_over_screens[1]
	elif theme == 3:
		game_over_screen = game_over_screens[2]

func set_etap(amount):
	var etap_str = ""
	if SettingsManager._settings["display"]["theme"] == 0:
		etap_str = str(amount)
	else:
		etap_str = str(amount)
	get_node("../Top_ui/Etap").text = etap_str
		
func set_max_etap(amount):
	var max_etap_str = ""
	if SettingsManager._settings["display"]["theme"] == 0:
		max_etap_str = "BEST : " + str(amount)
	else:
		max_etap_str = str(amount)
	get_node("../Top_ui/High_Score").text = max_etap_str
	
func _on_Grid_brick_passed():
	if passed_bricks == 2:
		passed_bricks = 0
		emit_signal("give_new_bricks")
		etap += 1
		set_etap(etap)
		#GameDataManager.game_data["current_etap"] = etap
		var max_etapp = GameDataManager.game_data["max_etap"]
		if etap > max_etapp:
			GameDataManager.game_data["max_etap"] = etap
		GameDataManager.save_game()
		return
	else:
		passed_bricks += 1



func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and go_back_timer.is_stopped():
# warning-ignore:return_value_discarded
		#get_tree().change_scene("res://Scenes/MainScreen.tscn")
		pass


func _on_Grid_game_over():
	var screen = game_over_screen.instance()
	get_parent().add_child(screen)
	screen.screen_in()
	screen.connect("btn_pressed", self, "_on_btn_pressed")


func _on_Replay_Button_pressed():
	GameDataManager.game_data["first_run"] = false
	GameDataManager.game_data["current_etap"] = 1
	GameDataManager.save_game()
# warning-ignore:return_value_discarded
	var theme = SettingsManager._settings["display"]["theme"]
	if theme == 0:
		get_tree().change_scene_to(LoadScreens.Theme_0)
	elif theme == 1:
		get_tree().change_scene_to(LoadScreens.Theme_1)
	elif theme == 2:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(LoadScreens.Theme_2)
	elif theme == 3:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(LoadScreens.Theme_3)


func _on_Grid_game_stucked():
	var screen = game_over_screen.instance()
	get_parent().add_child(screen)
	screen.screen_in()
	screen.connect("btn_pressed", self, "_on_btn_pressed")


func _on_Home_Button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(LoadScreens.MainScreen)



func _on_Replay_Button2_pressed():
	GameDataManager.game_data["first_run"] = false
	GameDataManager.game_data["hammer_booster"]["first_run"] = false
	GameDataManager.game_data["current_etap"] = 1
	GameDataManager.save_game()
# warning-ignore:return_value_discarded
	var theme = SettingsManager._settings["display"]["theme"]
	if theme == 0:
		get_tree().change_scene_to(LoadScreens.Theme_0)
	elif theme == 1:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(LoadScreens.Theme_1)
	elif theme == 2:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(LoadScreens.Theme_2)
	elif theme == 3:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(LoadScreens.Theme_3)

