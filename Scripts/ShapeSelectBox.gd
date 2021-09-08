extends Node2D

signal selected_shape(type)

export (Texture) var square_plane
export (Texture) var triangle_plane
export (Texture) var star_plane
export (Texture) var circle_plane
export (Texture) var box_plane
export (Texture) var square
export (Texture) var triangle
export (Texture) var star
export (Texture) var circle
export (Texture) var box

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(1,1,1,0)
	screen_in()
	z_index = 2
	screen_in_anim()
	zoom_in_out_animation()

func screen_in_anim():
	$AnimationPlayer.play("screen_in")

func zoom_in_out_animation():
	$AnimationPlayer2.play("zoom_in_out_select_box")

func set_theme(theme_no : int):
	if theme_no == 0:
		set_textures(circle, "circle")
		set_textures(square, "square")
		set_textures(star, "star")
		set_textures(triangle, "triangle")
		set_textures(box, "empty")
		set_modulates(Color(1,1,1,1), "circle")
		set_modulates(Color(1,1,1,1), "square")
		set_modulates(Color(1,1,1,1), "star")
		set_modulates(Color(1,1,1,1), "triangle")
		set_modulates(Color(1,1,1,1), "empty")
		$box.get("custom_styles/panel").bg_color = Color("96efbb00")
		$box_shadow/Panel.get("custom_styles/panel").bg_color = Color("96efbb00")
	elif theme_no == 1:
		set_textures(circle_plane, "circle")
		set_textures(square_plane, "square")
		set_textures(star_plane, "star")
		set_textures(triangle_plane, "triangle")
		set_textures(box_plane, "empty")
		set_modulates(Color("ffc63e"), "circle")
		set_modulates(Color("5cbee4"), "square")
		set_modulates(Color("97db54"), "star")
		set_modulates(Color("db6454"), "triangle")
		set_modulates(Color("ebead9"), "empty")
		$box.get("custom_styles/panel").bg_color = Color("91949365")
		$box_shadow/Panel.get("custom_styles/panel").bg_color = Color("91949365")
	elif theme_no == 2:
		set_textures(circle_plane, "circle")
		set_textures(square_plane, "square")
		set_textures(star_plane, "star")
		set_textures(triangle_plane, "triangle")
		set_textures(box_plane, "empty")
		set_modulates(Color("e76b85"), "circle")
		set_modulates(Color("ee934a"), "square")
		set_modulates(Color("dd6756"), "star")
		set_modulates(Color("96dc55"), "triangle")
		set_modulates(Color("363636"), "empty")
		$box.get("custom_styles/panel").bg_color = Color("8c7689ff")
		$box_shadow/Panel.get("custom_styles/panel").bg_color = Color("8c7689ff")
	elif theme_no == 3:
		set_textures(circle_plane, "circle")
		set_textures(square_plane, "square")
		set_textures(star_plane, "star")
		set_textures(triangle_plane, "triangle")
		set_textures(box_plane, "empty")
		set_modulates(Color("ec4e41"), "circle")
		set_modulates(Color("36bde4"), "square")
		set_modulates(Color("e1ba1c"), "star")
		set_modulates(Color("98dc55"), "triangle")
		set_modulates(Color("40206d"), "empty")
		$box.get("custom_styles/panel").bg_color = Color("8cd0afff")
		$box_shadow/Panel.get("custom_styles/panel").bg_color = Color("8cd0afff")
		
		
func set_textures(txtr : Texture, type : String):
	var path = "box/HBoxContainer/" + type
	get_node(path).get("custom_styles/normal").texture = txtr
	get_node(path).get("custom_styles/pressed").texture = txtr
	get_node(path).get("custom_styles/hover").texture = txtr

func set_modulates(clr : Color, type : String):
	var path = "box/HBoxContainer/" + type
	get_node(path).get("custom_styles/normal").modulate_color = clr
	get_node(path).get("custom_styles/pressed").modulate_color = clr
	get_node(path).get("custom_styles/hover").modulate_color = clr

func screen_in():
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func set_box_shadow_pos(pos):
	$box_shadow.global_position = pos

func attention_animation():
	$AnimationPlayer.play("attention_animation")


func _on_circle_pressed():
	emit_signal("selected_shape", "circle")
	queue_free()


func _on_triangle_pressed():
	emit_signal("selected_shape", "triangle")
	queue_free()


func _on_square_pressed():
	emit_signal("selected_shape", "square")
	queue_free()


func _on_star_pressed():
	emit_signal("selected_shape", "star")
	queue_free()


func _on_empty_pressed():
	emit_signal("selected_shape", "empty")
	queue_free()

