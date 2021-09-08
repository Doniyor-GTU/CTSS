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
	set_game_over_screen()
	rnd.randomize()
	var left_bricks_count = GameDataManager.game_data["current_bricks"].size()
	if left_bricks_count != 0:
		passed_bricks = 3 - left_bricks_count
	etap = GameDataManager.game_data["current_etap"]
	max_etap = GameDataManager.game_data["max_etap"]
	set_etap(etap)
	set_max_etap(max_etap)
	$AdMob/StartLoadTimer.start()

func set_game_over_screen():
	var theme = SettingsManager._settings["display"]["theme"]
	if theme == 1:
		game_over_screen = game_over_screens[0]
	elif theme == 2:
		game_over_screen = game_over_screens[1]
	elif theme == 3:
		game_over_screen = game_over_screens[2]

func set_etap(amount):
	var first_pressed_turn = GameDataManager.game_data["hammer_booster"]["first_used_turn"]
	var etap_str = ""
	get_node("../Turn_Label").set_label(amount)
	get_node("../Turn_Label").screen_in()
	if SettingsManager._settings["display"]["theme"] == 0:
		get_node("../Top_ui").score_increase_effect(true)
		#etap_str = "TURN : " + str(amount)
		etap_str = str(amount)
	else:
		get_node("../Top_ui").score_increase_effect(false)
		etap_str = str(amount)
	get_node("../Top_ui/Etap").text = etap_str
	get_node("../Top_ui/Hammer_Button").set_progress(first_pressed_turn, amount)
		
func set_max_etap(amount):
	var max_etap_str = ""
	if SettingsManager._settings["display"]["theme"] == 0:
		max_etap_str = "BEST " + str(amount)
	else:
		max_etap_str = str(amount)
	get_node("../Top_ui/High_Score").text = max_etap_str
	
func _on_Grid_brick_passed():
	if passed_bricks == 2:
		passed_bricks = 0
		emit_signal("give_new_bricks")
		etap += 1
		set_etap(etap)
		GameDataManager.game_data["current_etap"] = etap
		var max_etapp = GameDataManager.game_data["max_etap"]
		if etap > max_etapp:
			GameDataManager.game_data["max_etap"] = etap
		GameDataManager.save_game()
		return
	else:
		passed_bricks += 1


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and go_back_timer.is_stopped() and not get_tree().paused:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/MainScreen.tscn")
		if $AdMob.is_interstitial_loaded():
			$AdMob.hide_banner()
			$AdMob.show_interstitial()

		

func _on_Grid_game_over():
	var screen = game_over_screen.instance()
	get_parent().add_child(screen)
	screen.screen_in()
	screen.connect("btn_pressed", self, "_on_btn_pressed")
	if $AdMob.is_interstitial_loaded():
		$AdMob.hide_banner()
		$AdMob.show_interstitial()
	elif $AdMob.is_rewarded_video_loaded():
		$AdMob.hide_banner()
		$AdMob.show_rewarded_video()
	


func _on_btn_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_Replay_Button_pressed():
	$AdMob.hide_banner()
	GameDataManager.game_data["hammer_booster"]["state"] = "ACTIVE"
	GameDataManager.game_data["current_bricks"] = {}
	GameDataManager.game_data["save_array"] = []
	GameDataManager.game_data["current_etap"] = 1
	GameDataManager.game_data["score"] = 0
	GameDataManager.save_game()
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()



func _on_Grid_game_stucked():
	var screen = game_over_screen.instance()
	get_parent().add_child(screen)
	screen.screen_in()
	screen.connect("btn_pressed", self, "_on_btn_pressed")
	if $AdMob.is_interstitial_loaded():
		$AdMob.hide_banner()
		$AdMob.show_interstitial()
	elif $AdMob.is_rewarded_video_loaded():
		$AdMob.hide_banner()
		$AdMob.show_rewarded_video()



func _on_Home_Button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(LoadScreens.MainScreen)
	if $AdMob.is_interstitial_loaded():
		$AdMob.hide_banner()
		$AdMob.show_interstitial()
#
#
func _on_AdMob_banner_loaded():
	$AdMob.show_banner()
	$AdMob/BannerReloadTimer.start()

# warning-ignore:unused_argument
func _on_AdMob_banner_failed_to_load(error_code):
	$AdMob/BannerLoadTimer.start()

# warning-ignore:unused_argument
func _on_AdMob_interstitial_failed_to_load(error_code):
	$AdMob/InterstitialLoadTimer.start()

# warning-ignore:unused_argument
func _on_AdMob_rewarded_video_failed_to_load(error_code):
	$AdMob/RewardLoadTimer.start()
	print("reload")


func _on_BannerLoadTimer_timeout():
	$AdMob.load_banner()


func _on_InterstitialLoadTimer_timeout():
	$AdMob.load_interstitial()


func _on_RewardLoadTimer_timeout():
	$AdMob.load_rewarded_video()

func _on_StartLoadTimer_timeout():
	$AdMob.load_banner()
	$AdMob.load_interstitial()
	$AdMob.load_rewarded_video()

func _on_Hammer_Button_watch_add():
	if $AdMob.is_rewarded_video_loaded():
		$AdMob.show_rewarded_video()
	else:
		if $AdMob.is_interstitial_loaded():
			$AdMob.show_interstitial()
			get_node("../Top_ui/Hammer_Button").activate()
			get_node("../Top_ui/Hammer_Button").active_animation()
		print("No internet connection")
		get_node("../Top_ui/Hammer_Button/AnimationPlayer").stop(true)
		$AdMob.load_rewarded_video()
		get_node("../Top_ui").error_msg_show()

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_AdMob_rewarded(currency, ammount):
	get_node("../Top_ui/Hammer_Button").activate()
	get_node("../Top_ui/Hammer_Button").active_animation()

func _on_AdMob_rewarded_video_closed():
	$AdMob.load_rewarded_video()


func _on_BannerReloadTimer_timeout():
	$AdMob.hide_banner()
	$AdMob.load_banner()


func _on_AdMob_interstitial_closed():
	$AdMob.load_interstitial()
