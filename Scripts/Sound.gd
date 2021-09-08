extends Node

func _ready():
	SoundManager.play_fixed_sound("start_game")


func _on_Grid_brick_passed():
	SoundManager.play_fixed_sound("placed")



func _on_Grid_brick_wrong_place():
	SoundManager.play_fixed_sound("wrong_place")


func _on_Grid_destroyed():
	SoundManager.play_fixed_sound("matched")


func _on_brick_panel4_brick_rotated():
	SoundManager.play_fixed_sound("turn_brick")


func _on_brick_panel5_brick_rotated():
	SoundManager.play_fixed_sound("turn_brick")


func _on_brick_panel6_brick_rotated():
	SoundManager.play_fixed_sound("turn_brick")



func _on_brick_panel4_bricks_added():
	SoundManager.play_fixed_sound("new_bricks", -15, 0.7)


func _on_brick_panel5_bricks_added():
	SoundManager.play_fixed_sound("new_bricks", -15, 0.7)


func _on_brick_panel6_bricks_added():
	SoundManager.play_fixed_sound("new_bricks", -15, 0.7)


func _on_Grid_shape_added():
	SoundManager.play_fixed_sound("placed")


func _on_Home_Button_pressed():
	SoundManager.play_fixed_sound("placed")


func _on_Hammer_Button_pressed():
	SoundManager.play_fixed_sound("placed")


func _on_Grid_error_sound():
	SoundManager.play_fixed_sound("wrong_place")
