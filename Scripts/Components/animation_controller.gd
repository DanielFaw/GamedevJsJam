extends Node2D
class_name PlayerAnimationController

@export var animation_frames := 4
@export var is_player := true

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var player : Player = SceneResources.get_resource("Player")

var last_frame := 0
var frame_delay := 0.1
var frame_counter : float = 0


var move_direction := Vector2.ZERO
var aim_dir := Vector2.ZERO
var last_aim_dir := Vector2.ZERO

func _process(delta : float) -> void:
	if is_player:
		look_at(get_global_mouse_position())
	else:
		$Sprite2D.look_at(player.global_position)
		$Sprite2D.rotation_degrees -= 90
	if move_direction == Vector2.ZERO && aim_dir == last_aim_dir:
		last_frame = 1
		if audio.playing == true:
			audio.stop()
	else:
		if move_direction == Vector2.ZERO:
			audio.stop()
		elif audio.playing == false:
			audio.play()
		frame_counter += delta
		if frame_counter >= frame_delay:
			frame_counter = 0
			last_frame = (last_frame + 1) % animation_frames
	
	$Sprite2D.frame = last_frame
	last_aim_dir = aim_dir
	pass
