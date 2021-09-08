extends Node2D

signal mouse_released(pos)
signal dragged_brick(obj)
signal brick_rotated

export (Texture) var circle
export (Texture) var star
export (Texture) var triangle
export (Texture) var square
# this should be brick_type not grid_type
export (Array,Array) var grid_type
export (String) var brick_type
export (int) var degree = 0
var initial_pos = Vector2()
var matched = false
var is_movable = true
onready var icons_array = [[$icons/icon1,$icons/icon2,$icons/icon3],[$icons/icon4,$icons/icon5,$icons/icon6],[$icons/icon7,$icons/icon8,$icons/icon9]]
var brick_type_array = []
var plane_textures = [
	preload("res://Art/circle_plane.png"),
	preload("res://Art/square_plane.png"),
	preload("res://Art/star_plane.png"),
	preload("res://Art/triangle_plane.png")]

func _ready():
	set_textures()
	brick_type_array = grid_type.duplicate(true)
	unvisible_all_icons()
	set_process(false)
	generate_brick(brick_type_array)


func set_textures():
	var theme = SettingsManager._settings["display"]["theme"] 
	if theme != 0 :
		circle = plane_textures[0]
		square = plane_textures[1]
		star = plane_textures[2]
		triangle = plane_textures[3]

func set_texture_color(node, shape):
	if SettingsManager._settings["display"]["theme"] == 1:
		if shape == "square":
			node.modulate = Color("5cbee4")
		elif shape == "triangle":
			node.modulate = Color("db6454")
		elif shape == "circle":
			node.modulate = Color("ffc63e")
		elif shape == "star":
			node.modulate = Color("97db54")
	elif SettingsManager._settings["display"]["theme"] == 2:
		if shape == "square":
			node.modulate = Color("ee934a")
		elif shape == "triangle":
			node.modulate = Color("96dc55")
		elif shape == "circle":
			node.modulate = Color("e76b85")
		elif shape == "star":
			node.modulate = Color("dd6756")
	elif SettingsManager._settings["display"]["theme"] == 3:
		if shape == "square":
			node.modulate = Color("36bde4")
		elif shape == "triangle":
			node.modulate = Color("98dc55")
		elif shape == "circle":
			node.modulate = Color("ec4e41")
		elif shape == "star":
			node.modulate = Color("e1ba1c")
	

func generate_brick(arr):
	for elt in arr:
		if elt[1] != "null":
			if elt[1] == "square":
				set_texture_color(icons_array[elt[0].x][elt[0].y], elt[1])
				icons_array[elt[0].x][elt[0].y].texture = square
			elif elt[1] == "triangle":
				set_texture_color(icons_array[elt[0].x][elt[0].y], elt[1])
				icons_array[elt[0].x][elt[0].y].texture = triangle
			elif elt[1] == "circle":
				set_texture_color(icons_array[elt[0].x][elt[0].y], elt[1])
				icons_array[elt[0].x][elt[0].y].texture = circle
			elif elt[1] == "star":
				set_texture_color(icons_array[elt[0].x][elt[0].y], elt[1])
				icons_array[elt[0].x][elt[0].y].texture = star
			icons_array[elt[0].x][elt[0].y].visible = true


func unvisible_all_icons():
	for row in icons_array:
		for col in row:
			if col != null:
				col.visible = false

func dim():
	for icon in $icons.get_children():
		$ExpandTween.interpolate_property(icon, "rect_scale", Vector2(1,1), Vector2(1.2,1.2), 0.4, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$ExpandTween.start()
	#$icons.modulate = Color(1,1,1,0.5)

func screen_in(time = 0.5):
	scale = Vector2(0,0)
	$Tween.interpolate_property(self, "scale", Vector2(0,0), Vector2(1,1), time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func screen_in_from_down(time = 0.5):
	var current_pos = position
	position = current_pos + Vector2(0,300)
	$Tween.interpolate_property(self, "position", current_pos + Vector2(0,300), current_pos, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	initial_pos = global_position


# warning-ignore:function_conflicts_variable
func initial_pos():
	global_position = initial_pos
	scale = Vector2(0.7,0.7)

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_pressed("ui_touch"):
		if  $Timer.is_stopped():
			global_position = get_global_mouse_position() + Vector2(0,-120)
			scale = Vector2(1.1,1.1)
			emit_signal("dragged_brick", self)
	if Input.is_action_just_released("ui_touch"):
		if not $Timer.is_stopped():
			rotate_brick()
			set_process(false)
			initial_pos()
		else:
			set_process(false)
			emit_signal("mouse_released", global_position)
			initial_pos()

func generate_array(row, col):
	var new_arr = []
# warning-ignore:unused_variable
	for i in range(row):
		var arr2 = []
# warning-ignore:unused_variable
		for j in range(col):
			arr2.append(null)
		new_arr.append(arr2)
	return new_arr

func rotate_matrix(arr):
	# arr should be 3x3
	var new_arr = generate_array(3, 3)
	new_arr[0][0] = arr[0][2]
	new_arr[0][1] = arr[1][2]
	new_arr[0][2] = arr[2][2]
	new_arr[1][0] = arr[0][1]
	new_arr[1][1] = arr[1][1]
	new_arr[1][2] = arr[2][1]
	new_arr[2][0] = arr[0][0]
	new_arr[2][1] = arr[1][0]
	new_arr[2][2] = arr[2][0]
	return new_arr

func exit_animation(time):
	$ExitTween.interpolate_property(self, "scale", Vector2(1,1), Vector2(0,0), time, Tween.TRANS_BACK, Tween.EASE_IN)
	$ExitTween.start()
	yield($ExitTween, "tween_completed")
	queue_free()

func rotate_brick():
	if brick_type != "square" and brick_type != "triangle" and brick_type != "star" and brick_type != "circle" :
		unvisible_all_icons()
		#rotate_shapes(90)
		var new_arr = generate_array(3,3)
		var n = 0
		for i in range(3):
			for j in range(3):
				new_arr[i][j] = brick_type_array[n][1]
				n += 1
		var rot_arr = rotate_matrix(new_arr)
		var m = 0
		for i in range(3):
			for j in range(3):
				brick_type_array[m][1] = rot_arr[i][j] 
				m += 1
		generate_brick(brick_type_array)
		degree += 90
		emit_signal("brick_rotated")

func rotate_and_return_copy(arr = brick_type_array):
	var type_arr = arr.duplicate(true)
	var new_arr = generate_array(3,3)
	var n = 0
	for i in range(3):
		for j in range(3):
			new_arr[i][j] = type_arr[n][1]
			n += 1
	var rot_arr = rotate_matrix(new_arr)
	var m = 0
	for i in range(3):
		for j in range(3):
			type_arr[m][1] = rot_arr[i][j] 
			m += 1
	return type_arr

# warning-ignore:unused_argument
func pressed():
	if is_movable:
		$Timer.start()
		set_process(true)



func _on_icon1_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		pressed()


func _on_icon2_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		pressed()


func _on_icon3_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		pressed()


func _on_icon4_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		pressed()


func _on_icon5_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		pressed()


func _on_icon6_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		pressed()


func _on_icon7_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		pressed()


func _on_icon8_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		pressed()


func _on_icon9_gui_input(event):
	if event.is_action_pressed("ui_touch"):
		pressed()

