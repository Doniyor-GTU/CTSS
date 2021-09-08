extends Control

export (Texture) var square
export (Texture) var triangle
export (Texture) var circle
export (Texture) var star
export (Color) var square_modulate = Color(1,1,1,1)
export (Color) var triangle_modulate = Color(1,1,1,1)
export (Color) var circle_modulate = Color(1,1,1,1)
export (Color) var star_modulate = Color(1,1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("rotate")
	$brick/icon.texture = square
	$brick/icon2.texture = triangle
	$brick/icon3.texture = star
	$brick/icon4.texture = circle
	$brick/icon.modulate = square_modulate
	$brick/icon2.modulate = triangle_modulate
	$brick/icon3.modulate = star_modulate
	$brick/icon4.modulate = circle_modulate

