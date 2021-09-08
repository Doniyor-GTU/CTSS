extends Button

signal watch_add
signal btn_pressed

enum {ACTIVE, PROGRESSING, WATCH_ADD}

export (Texture) var  normal_texture
export (Texture) var add_texture
export (Texture) var pressed_texture
export (bool) var animations_on = true
export (Color) var modulate_color = Color(1,1,1,1)
export (bool) var disable = false

var state = ACTIVE
var btn_active_cycle = 10
var first_pressed_turn
var current_turn
var is_add_loaded = false

func _ready():
	first_pressed_turn = GameDataManager.game_data["hammer_booster"]["first_used_turn"]
	current_turn = GameDataManager.game_data["current_etap"]
	$TextureProgress.texture_progress = normal_texture
	$TextureProgress.tint_progress = modulate_color
	load_state()
	set_btn_state()

func load_state():
	var saved_state = GameDataManager.game_data["hammer_booster"]["state"]
	if saved_state == "ACTIVE":
		state = ACTIVE
	elif saved_state == "PROGRESSING":
		state = PROGRESSING
	elif saved_state == "WATCH_ADD":
		state = WATCH_ADD
	else:
		print("Default Hammer btn state")
		state = ACTIVE

func set_btn_state():
	if not disable:
		if state == ACTIVE:
			activate()
		elif state == PROGRESSING:
			set_progress(first_pressed_turn, current_turn)
		elif state == WATCH_ADD:
			activete_add()
	else:
		disabled = true

func activate():
	toggle_mode = true
	disabled = false
	pressed = false
	$TextureProgress.visible = false
	state = ACTIVE
	get("custom_styles/normal").texture = normal_texture
	get("custom_styles/hover").texture = normal_texture
	get("custom_styles/pressed").texture = pressed_texture
	if animations_on:
		$AnimationPlayer.play("attention")
	GameDataManager.game_data["hammer_booster"]["state"] = "ACTIVE"
	GameDataManager.save_game()

func activete_add():
	toggle_mode = false
	disabled = false
	state = WATCH_ADD
	$TextureProgress.visible = false
	$TextureProgress.value = 0
	get("custom_styles/normal").texture = add_texture
	get("custom_styles/hover").texture = add_texture
	get("custom_styles/pressed").texture = add_texture
	if not $AnimationPlayer.is_playing() and is_add_loaded and animations_on:
		$AnimationPlayer.play("attention")
	GameDataManager.game_data["hammer_booster"]["state"] = "WATCH_ADD"
	GameDataManager.save_game()

func set_progress(started_turn : int, this_turn : int):
	if (started_turn != -1) and state == PROGRESSING:
		var value = ((this_turn - started_turn) % btn_active_cycle) * (100 / btn_active_cycle)
		if value == 0 and started_turn != this_turn:
			activete_add()
		else:
			if $AnimationPlayer.is_playing():
				$AnimationPlayer.stop(true)
			disabled = true
			$AnimationPlayer.play("active")
			$TextureProgress.value = value
			$TextureProgress.visible = true

func active_animation():
	if animations_on:
		$AnimationPlayer.play("attention")

func _on_Hammer_Button_pressed():
	if state == ACTIVE:
		emit_signal("btn_pressed")
		pressed = true
	elif state == WATCH_ADD:
		emit_signal("watch_add")



func _on_AdMob_rewarded_video_loaded():
	is_add_loaded = true
	if not $AnimationPlayer.is_playing() and state == WATCH_ADD and animations_on:
		$AnimationPlayer.play("attention")
