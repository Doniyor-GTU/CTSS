extends Control

signal mouse_released(mouse_position)
signal dragged_brickk(objectt)
signal bricks_added
signal brick_rotated

var rnd = RandomNumberGenerator.new()
var current_brick
onready var grid_node = get_node("../../Grid")
export (int) var panel_no

var possible_bricks = [
	preload("res://Scenes/Components/Bricks/square.tscn"),
	preload("res://Scenes/Components/Bricks/triangle.tscn"),
	preload("res://Scenes/Components/Bricks/star.tscn"),
	preload("res://Scenes/Components/Bricks/circle.tscn"),
	preload("res://Scenes/Components/Bricks/2_h.tscn"),
	preload("res://Scenes/Components/Bricks/bottom_corner.tscn"),
	preload("res://Scenes/Components/Bricks/top_corner.tscn"),
	preload("res://Scenes/Components/Bricks/3_h.tscn"),
	preload("res://Scenes/Components/Bricks/2x2.tscn"),
	preload("res://Scenes/Components/Bricks/T.tscn"),
	preload("res://Scenes/Components/Bricks/L_down.tscn"),
	preload("res://Scenes/Components/Bricks/L_up.tscn"),
	preload("res://Scenes/Components/Bricks/z_brick.tscn"),
	preload("res://Scenes/Components/Bricks/z_inverse.tscn")
]

var possible_bricks_dict = {
	"square": preload("res://Scenes/Components/Bricks/square.tscn"),
	"triangle": preload("res://Scenes/Components/Bricks/triangle.tscn"),
	"star": preload("res://Scenes/Components/Bricks/star.tscn"),
	"circle": preload("res://Scenes/Components/Bricks/circle.tscn"),
	"top_corner": preload("res://Scenes/Components/Bricks/top_corner.tscn"),
	"bottom_corner": preload("res://Scenes/Components/Bricks/bottom_corner.tscn"),
	"2_h": preload("res://Scenes/Components/Bricks/2_h.tscn"),
	"3_h": preload("res://Scenes/Components/Bricks/3_h.tscn"),
	"z": preload("res://Scenes/Components/Bricks/z_brick.tscn"),
	"2x2": preload("res://Scenes/Components/Bricks/2x2.tscn"),
	"T": preload("res://Scenes/Components/Bricks/T.tscn"),
	"L_down": preload("res://Scenes/Components/Bricks/L_down.tscn"),
	"L_up": preload("res://Scenes/Components/Bricks/L_up.tscn"),
	"z_inverse": preload("res://Scenes/Components/Bricks/z_inverse.tscn")
}

var brick_probability = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,0,1,2,3,4,5,6]
var hard_bricks = ["L_up", "L_down", "T", "2x2", "3_h", "z_inverse", "z"]

func _ready():
	rnd.randomize()
	if GameDataManager.game_data["current_bricks"].size() != 0:
		var saved_bricks = GameDataManager.game_data["current_bricks"]
		for key in saved_bricks.keys():
			if int(key) == panel_no:
				add_given_brick(saved_bricks[key])
	else:
		add_random_brick()


func add_random_brick():
	$Timer.start()
	var current_turn = GameDataManager.game_data["current_etap"]
	rect_clip_content = true
	var rand_idx
#	if panel_no == 1 and ((current_turn >= 20 and current_turn < 25) or (current_turn >= 35 and current_turn < 40) or (current_turn >= 50 and current_turn < 55) or (current_turn >= 65 and current_turn < 70) or (current_turn >= 80 and current_turn < 85)):
#		rand_idx = rnd.randi_range(0, 6)
	if panel_no == 2:
		var rand_no = rnd.randi_range(0, brick_probability.size()-1)
		rand_idx = brick_probability[rand_no]
	else:
		rand_idx = rnd.randi_range(0, possible_bricks.size()-1)
	var brick_path = possible_bricks[rand_idx]
	var brick = brick_path.instance()
	add_child(brick)
	if panel_no == 3:
		var k = 0
		while not grid_node.is_place_exists(brick.brick_type_array) and k < 100:
			brick.queue_free()
			rand_idx = rnd.randi_range(0, possible_bricks.size()-1)
			brick_path = possible_bricks[rand_idx]
			brick = brick_path.instance()
			add_child(brick)
			k += 1
	brick.connect("mouse_released", self, "_on_mouse_released")
	brick.connect("dragged_brick", self, "_on_brick_is_dragged")
	brick.connect("brick_rotated", self, "_on_brick_rotated")
	brick.position = rect_size/2
	brick.initial_pos = brick.position
	brick.screen_in_from_down()
	current_brick = brick
	emit_signal("bricks_added")
	
func add_given_brick(brick_name):
	$Timer.start()
	rect_clip_content = true
	var brick_path = possible_bricks_dict[brick_name]
	var brick = brick_path.instance()
	add_child(brick)
	brick.connect("mouse_released", self, "_on_mouse_released")
	brick.connect("dragged_brick", self, "_on_brick_is_dragged")
	brick.connect("brick_rotated", self, "_on_brick_rotated")
	brick.position = rect_size/2
	brick.initial_pos = brick.position
	brick.screen_in_from_down()
	current_brick = brick
	emit_signal("bricks_added")
	
	
func _on_brick_rotated():
	emit_signal("brick_rotated")
	print("rotate")

func _on_brick_is_dragged(obj):
	emit_signal("dragged_brickk", obj)
	rect_clip_content = false

func _on_mouse_released(pos):
	emit_signal("mouse_released", pos)


func _on_Main_give_new_bricks():
	add_random_brick()



func _on_Panel_gui_input(event):
	var childrens = get_children()
	if $Timer.is_stopped() and childrens.size() > 1:
		if event.is_action_pressed("ui_touch"):
			if current_brick != null:
				current_brick.pressed()


