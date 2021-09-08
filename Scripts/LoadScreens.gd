extends Node

var MainScreen = preload("res://Scenes/MainScreen.tscn")
var Theme_0 = preload("res://Scenes/Game.tscn")
var Theme_1 = preload("res://Scenes/Game_theme1.tscn")
var Theme_2 = preload("res://Scenes/Game_theme2.tscn")
var Theme_3 = preload("res://Scenes/Game_theme3.tscn")
var ThemeScreen = preload("res://Scenes/ThemesScreen.tscn")
var Theme_0_Tutorial = preload("res://Scenes/Tutorial_theme0.tscn")
var BoosterTutorial = preload("res://Scenes/BoosterTutorial.tscn")
#var Theme_1_Tutorial = preload("res://Scenes/Tutorial_theme1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameDataManager.game_data["first_run"] == true :
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(Theme_0_Tutorial)
	elif GameDataManager.game_data["hammer_booster"]["first_run"] == true:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(BoosterTutorial)

