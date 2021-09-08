extends Label

onready var screen_size_x = get_viewport_rect().size.x
onready var screen_size_y = get_viewport_rect().size.y

onready var center_x = screen_size_x/2
onready var center_y = screen_size_y/2

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size_x = get_viewport_rect().size.x
	screen_size_y = get_viewport_rect().size.y
	center_x = screen_size_x/2 - rect_size.x/2
	center_y = screen_size_y/2
	var animation = $AnimationPlayer.get_animation("show_turn_number")
	animation.track_set_key_value(0,0, Vector2(-200, center_y - 100))
	animation.track_set_key_value(0,1, Vector2(center_x, center_y - 100))
	animation.track_set_key_value(0,2, Vector2(center_x, center_y - 100))
	animation.track_set_key_value(0,3, Vector2(screen_size_x + 200, center_y - 100))

func screen_in():
	$AnimationPlayer.play("show_turn_number")
	
func set_label(score : int):
	var text_str = "TURN " + str(score)
	text = text_str
