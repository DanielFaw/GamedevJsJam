extends Control

@export var play_btn : Button
@export var options_btn : Button
@export var back_btn : Button
@export var main_ui : Control
@export var options_ui : Control
@export var fade_rect : ColorRect

@export var audio_player : AudioStreamPlayer
@export var hover_sound : AudioStream
#@export var unhover_sound : AudioStream
@export var click_sound : AudioStream

@export var music : AudioStreamPlayer

#Tween stuff
var grow_size := Vector2(1.2, 1.2)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_ui.visible = true
	options_ui.visible = false
	make_dynamic(play_btn)
	make_dynamic(options_btn)
	make_dynamic(back_btn)
	
	play_btn.pressed.connect(play_game)
	options_btn.pressed.connect(show_options)
	back_btn.pressed.connect(hide_options)
	get_tree().create_tween().tween_property(music, "volume_db", -10, 3.0)
	pass # Replace with function body.

func play_game() -> void:
	#Fade to black then switch to main game scene?
	fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	if OS.is_debug_build():
		get_tree().create_tween().tween_property(music, "volume_db", -80, 1.5)
		await create_tween().tween_property(fade_rect, "color:a", 1, 1.5).finished
	SceneManager.change_scene("res://Scenes/main_game.tscn")
	pass

func show_options() -> void:
	main_ui.visible = true
	options_ui.visible = true
	main_ui.modulate.a = 1
	options_ui.modulate.a = 0
	
	create_tween().tween_property(main_ui, "modulate:a", 0, 0.25)
	await create_tween().tween_property(options_ui, "modulate:a", 1, 0.25)
	
	main_ui.visible = false
	
	pass

func hide_options() -> void:
	main_ui.visible = true
	options_ui.visible = true
	
	main_ui.modulate.a = 0
	options_ui.modulate.a = 1
	
	create_tween().tween_property(main_ui, "modulate:a", 1, 0.25)
	await create_tween().tween_property(options_ui, "modulate:a", 0, 0.25)
	
	options_ui.visible = false
	
	pass

func make_dynamic(ctrl : Button) -> void:
	ctrl.mouse_entered.connect(func() -> void: grow(ctrl))
	ctrl.mouse_exited.connect(func() -> void: shrink(ctrl))
	ctrl.pressed.connect(play_click)
	pass

func grow(ctrl : Control) -> void:
	if ctrl.scale != Vector2.ONE:
		await get_tree().create_timer(0.1).timeout
	ctrl.scale = Vector2.ONE
	audio_player.stream = hover_sound
	audio_player.play()
	await create_tween().tween_property(ctrl, "scale", grow_size, 0.2).set_trans(Tween.TRANS_BACK).finished
	pass

func shrink(ctrl: Control) -> void:
	if ctrl.scale != grow_size:
		await get_tree().create_timer(0.2).timeout
		ctrl.scale = grow_size
	#audio_player.stream = unhover_sound
	#audio_player.play()
	await create_tween().tween_property(ctrl, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_CIRC).finished
	pass

func play_click() -> void:
	audio_player.stream = click_sound
	audio_player.play()
	pass
