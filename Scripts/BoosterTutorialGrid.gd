extends Node2D

enum {BOOSTER, PLAY, GAME_OVER, WIN}

var state = PLAY

signal brick_passed
signal shape_passed
signal game_over
signal game_stucked
# warning-ignore:unused_signal
signal brick_wrong_place
signal destroyed
signal tutorial_end
signal hammer_booster_place(where)
signal error_sound


export(int) var rows = 0
export (int) var columns = 0
export(int) var x_start
export(int) var y_start
export(int) var offset
export(Color) var border_color

# Hammer Booster vars
var hammer_booster_step = 1
var shape_select_box
var shape_select_box_path = preload("res://Scenes/Components/ShapeSelectBox.tscn")

var is_box_border_exist = false
var box_border_path = preload("res://Scenes/Components/BoxBorder.tscn")
onready var grid_container_node = get_node("../GridContainer")
onready var Bottom_ui_node = get_node("../Bottom_ui")
var current_drawed_brick
var grid_array = []
var explosion_node = preload("res://Art/Explosion Sprites/ExplosionEffect.tscn")
var explosion_node_plane = preload("res://Art/Explosion Sprites/ExplosionEffectPlane.tscn")
var possible_bricks = {
	"square": preload("res://Scenes/Components/Bricks/square.tscn"),
	"triangle": preload("res://Scenes/Components/Bricks/triangle.tscn"),
	"star": preload("res://Scenes/Components/Bricks/star.tscn"),
	"circle": preload("res://Scenes/Components/Bricks/circle.tscn"),
	"z": preload("res://Scenes/Components/Bricks/z_brick.tscn"),
	"2_h": preload("res://Scenes/Components/Bricks/2_h.tscn"),
	"3_h": preload("res://Scenes/Components/Bricks/3_h.tscn"),
	"bottom_corner": preload("res://Scenes/Components/Bricks/bottom_corner.tscn"),
	"2x2": preload("res://Scenes/Components/Bricks/2x2.tscn"),
	"T": preload("res://Scenes/Components/Bricks/T.tscn"),
	"L_down": preload("res://Scenes/Components/Bricks/L_down.tscn"),
	"L_up": preload("res://Scenes/Components/Bricks/L_up.tscn"),
	"z_inverse": preload("res://Scenes/Components/Bricks/z_inverse.tscn"),
	"top_corner": preload("res://Scenes/Components/Bricks/top_corner.tscn")
	}
var finger_pos = preload("res://Scenes/Components/fingerSwipe.tscn")
var finger
var finger_start_pos
var finger_end_pos
var grid_pos_to_past = [Vector2(1,3), Vector2(1,6), Vector2(2,2), Vector2(4,1),Vector2(5,4)]
var brick_panel_no = [5,4,6,4,6]
var brick_right_angles = [0,0,90,0,0]
var brick_types = ["square", "circle", "3_h", "top_corner", "2_h"]
var index_no = 5
var is_play_finger_animation = false
var is_rotate_animation = false
var current_hint_brick

var gap_between_boxes 

func _ready():
	gap_between_boxes = get_node("../GridContainer").get("custom_constants/vseparation")
	x_start = grid_container_node.rect_position.x
	y_start = grid_container_node.rect_position.y
	grid_array = generate_2d_array()
	set_initial_board()
	#create_hint_brick(index_no)
	yield(get_tree().create_timer(0.5), "timeout")
	#set_finger_pos(index_no)
	finger = finger_pos.instance()
	add_child(finger)
	#play_finger_animation(finger_start_pos, finger_end_pos)
	set_process(false)
	is_play_finger_animation = false
	get_tree().paused = true
	finger.position = get_node("../Top_ui/Hammer_Button").rect_global_position + Vector2(30,30)
	finger.start_animation(Vector2(0,0),Vector2(0,0), "oneTap")

func set_initial_board():
	add_a_brick_to_grid(Vector2(1,3), "square")
	add_a_brick_to_grid(Vector2(3,3), "square")
	add_a_brick_to_grid(Vector2(2,2), "square")
	add_a_brick_to_grid(Vector2(2,4), "square")
	add_a_brick_to_grid(Vector2(2,3), "circle")

	

func generate_2d_array():
	var arr = []
	for i in range(rows):
		arr.append([])
		for j in columns:
			arr[i].append(null)
	return arr

func is_game_over():
	for row in grid_array:
		for col in row:
			if col == null:
				return false
	return true

func spawn_bricks(saved_array):
	if not saved_array == []:
		for i in range(saved_array.size()):
			for j in range(saved_array[i].size()):
				if saved_array[i][j] != null:
					add_a_brick_to_grid(Vector2(i,j), saved_array[i][j])

func grid_to_pixel(grid_pos):
	var row = grid_pos.x
	var column = grid_pos.y
	var new_x = x_start + 2*offset*column + offset + column*gap_between_boxes
	var new_y = y_start + 2*offset*row + offset + row*gap_between_boxes
	return Vector2(new_x, new_y)

func pixel_to_grid(pixel_pos):
	var pos_x = pixel_pos.x
	var pos_y = pixel_pos.y
	var column = (pos_x - x_start)
	var row = (pos_y - y_start)
	if row > 0 and column > 0:
		row = int(row) / (2*offset+gap_between_boxes)
		column = int(column) / (2*offset+gap_between_boxes)
	if (row <= rows - 1 and row >= 0) and (column <= columns - 1 and column >= 0):
		return Vector2(row, column)
	else:
		return null

func find_matches():
	var is_matched = false
	for i in range(rows):
		for j in range(columns):
			if grid_array[i][j] != null:
				var current_type = grid_array[i][j].brick_type
				if i > 0  and i < rows-1:
					if grid_array[i-1][j] != null and grid_array[i+1][j] != null:
						if grid_array[i-1][j].brick_type == current_type and grid_array[i+1][j].brick_type == current_type:
							grid_array[i-1][j].matched = true
							grid_array[i-1][j].dim()
							grid_array[i][j].matched = true
							grid_array[i][j].dim()
							grid_array[i+1][j].matched = true
							grid_array[i+1][j].dim()
							is_matched = true
				if j > 0  and j < columns-1:
					if grid_array[i][j-1] != null and grid_array[i][j+1] != null:
						if grid_array[i][j-1].brick_type == current_type and grid_array[i][j+1].brick_type == current_type:
							grid_array[i][j-1].matched = true
							grid_array[i][j-1].dim()
							grid_array[i][j].matched = true
							grid_array[i][j].dim()
							grid_array[i][j+1].matched = true
							grid_array[i][j+1].dim()
							is_matched = true
	if is_matched:
		get_node("../Destroy_Timer").start()

func destroy_a_shape(i,j):
	var temp_grid_array = grid_array.duplicate(true)
# warning-ignore:unused_variable
	var destroyed = false
	if is_idx_in_grid(i,j):
		if grid_array[i][j] != null:
			temp_grid_array[i][j] = null
			destroyed = true
			var theme = SettingsManager._settings["display"]["theme"]
			var explosion_effect = explosion_node.instance()
			if theme != 0:
				explosion_effect = explosion_node_plane.instance()
				explosion_effect.set_color(grid_array[i][j].get_node("icons/icon5").modulate)
			explosion_effect.position = grid_to_pixel(Vector2(i,j))
			add_child(explosion_effect)
			grid_array[i][j].queue_free()
	grid_array = temp_grid_array
	emit_signal("destroyed")
#	if destroyed:
#		var save_array = generate_save_array(temp_grid_array)
#		GameDataManager.game_data["save_array"] = save_array
#		GameDataManager.save_game()


func destroy_matches():
	var temp_grid_array = grid_array.duplicate(true)
# warning-ignore:unused_variable
	var destroyed = false
	var theme = SettingsManager._settings["display"]["theme"]
	for i in range(rows):
		for j in range(columns):
			if grid_array[i][j] != null:
				if grid_array[i][j].matched:
					temp_grid_array[i][j] = null
					destroyed = true
					var explosion_effect
					if theme != 0:
						explosion_effect = explosion_node_plane.instance()
						explosion_effect.set_color(grid_array[i][j].get_node("icons/icon5").modulate)
					else:
						explosion_effect = explosion_node.instance()
					explosion_effect.position = grid_to_pixel(Vector2(i,j))
					add_child(explosion_effect)
					grid_array[i][j].queue_free()
	grid_array = temp_grid_array
	emit_signal("destroyed")


func add_a_brick_to_grid(pos, type):
	var brick = possible_bricks[type].instance()
	add_child(brick)
	brick.position = grid_to_pixel(pos)
	brick.scale = Vector2(1,1)
	brick.is_movable = false
	brick.screen_in(0.2)
	grid_array[pos.x][pos.y] = brick

func add_brick_to_grid(pos,type_arr):
	var diff = pos - Vector2(1,1)
	for elt in type_arr:
		if elt[1] != "null":
			var brick = possible_bricks[elt[1]].instance()
			add_child(brick)
			brick.position = grid_to_pixel(Vector2(elt[0].x + diff.x, elt[0].y + diff.y))
			brick.scale = Vector2(1,1)
			brick.is_movable = false
			grid_array[elt[0].x + diff.x][elt[0].y + diff.y] = brick
	

func generate_save_array(array_to_save):
	var arr = []
	for row in array_to_save:
		var arr2 = []
		for col in row:
			if col != null:
				arr2.append(col.brick_type)
			else:
				arr2.append(null)
		arr.append(arr2)
	return arr

func is_idx_in_grid(row,column):
	if (row >= 0 and row < rows) and (column >= 0 and column < columns):
		return true
	return false
	
func is_grid_available(grid_position, type_arr):
	if grid_position != null:
		var diff = grid_position - Vector2(1,1)
		for elt in type_arr:
			if elt[1] != "null":
				if is_idx_in_grid(elt[0].x + diff.x, elt[0].y + diff.y):
					if grid_array[elt[0].x + diff.x][elt[0].y + diff.y] != null:
						return false
				else:
					return false
		return true
	return false
		
func is_place_exists(type_arr):
	for i in range(rows):
		for j in range(columns):
			if is_grid_available(Vector2(i,j), type_arr):
				return true
	return false

func is_game_stuck(current_bricks):
	# checks that 's there exist a place on board for current panel bricks
	for brick in current_bricks:
		if is_place_exists(brick.brick_type_array):
			print("place exists")
			return false
		var c = 0
		var rotated_brick_type_arr = brick.rotate_and_return_copy(brick.brick_type_array)
		while c<4:
			print("rotated")
			if is_place_exists(rotated_brick_type_arr):
				print("rotate checked and place exists")
				return false
			c+=1
			rotated_brick_type_arr = brick.rotate_and_return_copy(rotated_brick_type_arr)
	print("no place")
	return true
	
func check_is_game_stuck():
	var current_bricks_arr = Bottom_ui_node.get_current_bricks()
# warning-ignore:unused_variable
	var current_bricks_dictionary = Bottom_ui_node.get_current_bricks_as_dict()
# warning-ignore:shadowed_variable
	var state = is_game_stuck(current_bricks_arr)
	if state:
		yield(get_tree().create_timer(0.5),"timeout")
		print("game_stuck")
		emit_signal("game_stucked")

func check_is_game_over():
	if is_game_over():
#		var save_array = []
		emit_signal("game_over")
	
func past_brick(grid_pos, current_brick):
	if current_brick != null:
		if is_grid_available(grid_pos, current_brick.brick_type_array) and grid_pos == grid_pos_to_past[index_no] and (current_brick.degree - brick_right_angles[index_no]) % 360 == 0 and current_brick.brick_type == brick_types[index_no]:
			get_node("../GoBackTimer").start()
			add_brick_to_grid(grid_pos, current_brick.brick_type_array)
			emit_signal("brick_passed")
			find_matches()
			current_hint_brick.queue_free()
			current_brick.queue_free()
			yield(current_brick, "tree_exited")
			yield(get_tree().create_timer(0.5),"timeout")
			check_is_game_over()
			check_is_game_stuck()
			#stop_finger_animation()
			#finger_start_pos = Bottom_ui_node.get_node("brick_panel4").rect_global_position + Bottom_ui_node.get_node("brick_panel4").rect_size/2
			#index_no += 1
			#create_hint_brick(index_no)
			#set_finger_pos(index_no)
			#check_right_degree(index_no)
#			if is_rotate_animation == true:
#				play_finger_animation(finger_start_pos, finger_end_pos, "oneTap")
#			else:
#				play_finger_animation(finger_start_pos, finger_end_pos)
		else:
#			if is_rotate_animation == true:
#				play_finger_animation(finger_start_pos, finger_end_pos, "oneTap")
#			else:
#				play_finger_animation(finger_start_pos, finger_end_pos)
			current_brick.z_index = 0
			current_brick.initial_pos()
			#emit_signal("brick_wrong_place")

func print_arr(arr):
	for row in arr:
		print(row)

func check_right_degree(idx):
	if idx < grid_pos_to_past.size():
		var panel_path = "../Bottom_ui/brick_panel" + str(brick_panel_no[idx])
		var childrens = get_node(panel_path).get_children()
		if childrens.size() > 1:
			if (childrens[1].degree - brick_right_angles[idx]) % 360 != 0:
				is_rotate_animation = true

func set_finger_pos(idx):
	if idx < grid_pos_to_past.size():
		is_play_finger_animation = true
		var panel_name = "brick_panel" + str(brick_panel_no[idx])
		finger_start_pos = Bottom_ui_node.get_node(panel_name).rect_global_position + Bottom_ui_node.get_node(panel_name).rect_size/2
		finger_end_pos =  grid_to_pixel(grid_pos_to_past[idx])
	else:
		if finger != null:
			get_node("../Top_ui/Hammer_Button").disabled = false
			is_play_finger_animation = false
			get_tree().paused = true
			finger.position = get_node("../Top_ui/Hammer_Button").rect_global_position + Vector2(30,30)
			finger.start_animation(Vector2(0,0),Vector2(0,0), "oneTap")
			#emit_signal("tutorial_end")
		

func play_finger_animation(from, to, type = "swipeFinger"):
	if is_play_finger_animation:
		#finger = finger_pos.instance()
		#add_child(finger)
		finger.position = from
		finger.start_animation(from,to, type)

func stop_finger_animation():
	if finger != null:
		finger.stop_animation()

func create_hint_brick(idx : int):
	if idx < brick_types.size():
		current_hint_brick = possible_bricks[brick_types[idx]].instance()
		add_child(current_hint_brick)
		current_hint_brick.position = grid_to_pixel(grid_pos_to_past[idx])
		current_hint_brick.modulate = Color(1,1,1,0.4)
		current_hint_brick.is_movable = false
		current_hint_brick.scale = Vector2(0.9,0.9)
		while current_hint_brick.degree != brick_right_angles[idx]:
			current_hint_brick.rotate_brick()


func booster_input():
	if state == BOOSTER:
		if Input.is_action_just_released("ui_touch") and hammer_booster_step == 1:
			var mouse_pos = get_global_mouse_position()
			var pos = pixel_to_grid(mouse_pos)
			if pos == Vector2(2,3):
				clear_borders()
				if grid_array[pos.x][pos.y] != null:
					print("explode")
					destroy_a_shape(pos.x, pos.y)
					emit_signal("hammer_booster_place", "on_shape")
					finger.position = grid_to_pixel(Vector2(3,3)) + Vector2(5,5)
					finger.z_index = 3
				else:
					print("add shape")
					emit_signal("hammer_booster_place", "on_empty")
				shape_select_box = shape_select_box_path.instance()
				var shifting = Vector2(0,0)
				if pos.y == 0:
					shifting += Vector2(1,2)
				elif pos.y == 1:
					shifting += Vector2(1,1)
				elif pos.y == columns - 1:
					shifting += Vector2(1,-2)
				elif pos.y == columns - 2:
					shifting += Vector2(1,-1)
				else:
					shifting += Vector2(1,0)
				if pos.x == rows - 1:
					shifting += Vector2(-2,0)
				var theme_no = SettingsManager._settings["display"]["theme"]
				shape_select_box.position = grid_to_pixel(pos + shifting)
				shape_select_box.set_theme(theme_no)
				shape_select_box.connect("selected_shape", self, "on_shape_selected", [pos])
				add_child(shape_select_box)
				shape_select_box.set_box_shadow_pos(grid_to_pixel(pos))
				hammer_booster_step += 1
#			else:
#				print("not explode")
#				emit_signal("hammer_booster_place", "on_null")
#				set_process(false)
#				state = PLAY
#				get_tree().paused = false
		elif Input.is_action_just_released("ui_touch") and hammer_booster_step == 2:
			if shape_select_box != null:
				shape_select_box.attention_animation()
				emit_signal("error_sound")

func on_shape_selected(shape_type, pos):
	stop_finger_animation()
	set_process(false)
	state = PLAY
	get_tree().paused = false
	hammer_booster_step = 1
	if shape_type == "circle":
		add_a_brick_to_grid(pos, "circle")
		emit_signal("shape_passed")
	elif shape_type == "square":
		add_a_brick_to_grid(pos, "square")
		emit_signal("shape_passed")
	elif shape_type == "star":
		add_a_brick_to_grid(pos, "star")
		emit_signal("shape_passed")
	elif shape_type == "triangle":
		add_a_brick_to_grid(pos, "triangle")
		emit_signal("shape_passed")
	#var save_array = generate_save_array(grid_array)
	#GameDataManager.game_data["save_array"] = save_array
	#GameDataManager.save_game()
	if shape_type != "empty":
		find_matches()
	yield(get_tree().create_timer(0.6),"timeout")
	emit_signal("tutorial_end")
	

# warning-ignore:unused_argument
func _process(delta):
	#print("..............")
	booster_input()


func add_borders():
	if not is_box_border_exist:
		is_box_border_exist = true
		var childrens = get_node("../GridContainer").get_children()
		for box in childrens:
			var border = box_border_path.instance()
			border.set_color(border_color)
			box.add_child(border)
	
func clear_borders():
	is_box_border_exist = false
	var container = get_node("../GridContainer")
	for box in container.get_children():
		var border = box.get_children()
		if border.size() > 0:
			border[0].queue_free()

func _on_Destroy_Timer_timeout():
	destroy_matches()


func _on_Main_pause_screen_in():
	for row in grid_array:
		for col in row:
			if col != null:
				col.z_index = 0


func _on_GridContainer_resized():
	x_start = grid_container_node.rect_position.x
	y_start = grid_container_node.rect_position.y


func _on_brick_panel4_dragged_brickk(objectt):
	current_drawed_brick = objectt
	current_drawed_brick.z_index = 2
	stop_finger_animation()


func _on_brick_panel4_mouse_released(mouse_position):
	var grid_pos = pixel_to_grid(mouse_position)
	past_brick(grid_pos, current_drawed_brick)


func _on_brick_panel5_dragged_brickk(objectt):
	current_drawed_brick = objectt
	current_drawed_brick.z_index = 2
	stop_finger_animation()


func _on_brick_panel5_mouse_released(mouse_position):
	var grid_pos = pixel_to_grid(mouse_position)
	past_brick(grid_pos, current_drawed_brick)


func _on_brick_panel6_dragged_brickk(objectt):
	current_drawed_brick = objectt
	current_drawed_brick.z_index = 2
	stop_finger_animation()


func _on_brick_panel6_mouse_released(mouse_position):
	var grid_pos = pixel_to_grid(mouse_position)
	past_brick(grid_pos, current_drawed_brick)
	


# warning-ignore:unused_argument
func _on_brick_panel4_brick_rotated(this_brick, degree):
	if brick_panel_no[index_no] == 4:
		print("4")
		if (this_brick.degree - brick_right_angles[index_no]) % 360 == 0 :
			is_rotate_animation = false
			stop_finger_animation()
			past_brick(Vector2(7,7), this_brick)
		else:
			is_rotate_animation = true
			stop_finger_animation()
			past_brick(Vector2(7,7), this_brick)


# warning-ignore:unused_argument
func _on_brick_panel5_brick_rotated(this_brick, degree):
	if brick_panel_no[index_no] == 5:
		print("5")
		if (this_brick.degree - brick_right_angles[index_no]) % 360 == 0 :
			is_rotate_animation = false
			stop_finger_animation()
			past_brick(Vector2(7,7), this_brick)
		else:
			is_rotate_animation = true
			stop_finger_animation()
			past_brick(Vector2(7,7), this_brick)


# warning-ignore:unused_argument
func _on_brick_panel6_brick_rotated(this_brick, degree):
	if brick_panel_no[index_no] == 6:
		print("6")
		if (this_brick.degree - brick_right_angles[index_no]) % 360 == 0 :
			is_rotate_animation = false
			stop_finger_animation()
			past_brick(Vector2(7,7), this_brick)
		else:
			is_rotate_animation = true
			stop_finger_animation()
			past_brick(Vector2(7,7), this_brick)


func _on_Top_ui_hammer_booster_pressed():
	add_borders()
	stop_finger_animation()
	finger.position = grid_to_pixel(Vector2(2,3)) + Vector2(10,10)
	finger.start_animation(Vector2(0,0),Vector2(0,0), "oneTap")
	yield(get_tree().create_timer(0.3),"timeout")
	get_tree().paused = true
	state = BOOSTER
	set_process(true)
