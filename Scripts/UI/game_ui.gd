extends Control


@onready var player : Player = SceneResources.get_resource("Player")
@onready var main_game : MainGame = SceneResources.get_resource("MainGame")

@export var player_hp_bar : TextureProgressBar
@export var player_current_hp_label : Label
@export var player_max_hp_label : Label
@export var health_container : Control
@export var game_over_container : Control
@export var ftb : ColorRect
@export var game_over_text : Control
@export var game_over_button : Button

@export var music : AudioStreamPlayer

func _ready() -> void:
	game_over_container.visible = false
	player.health_comp.took_damage.connect(player_took_dmg)
	player_max_hp_label.text = str(player.health_comp.max_health)
	player_current_hp_label.text = str(player.health_comp.current_health)
	
	var new_hp_percent : float = player.health_comp.current_health / player.health_comp.max_health
	player_hp_bar.value = new_hp_percent * player.health_comp.max_health
	player.health_comp.died.connect(game_over)
	game_over_button.pressed.connect(main_menu)
	get_tree().create_tween().tween_property(music, "volume_db", -20, 3.0)
	pass

func main_menu() -> void:
	SceneManager.change_scene("res://Scenes/main_menu.tscn")
	pass

func game_over() -> void:
	main_game.end()
	health_container.visible = false
	game_over_container.visible = true
	game_over_text.visible = true
	game_over_text.modulate.a = 0
	ftb.visible = true
	ftb.modulate.a = 0
	get_tree().create_tween().tween_property(music, "volume_db", -80, 2.5)
	get_tree().create_tween().tween_property(game_over_text, "modulate", Color.WHITE, 2.5)
	await get_tree().create_tween().tween_property(ftb, "modulate", Color.BLACK, 2.5).finished
	
	pass

func player_took_dmg(src : DamageSource) -> void:
	var new_hp_percent : float = float(player.health_comp.current_health) / float(player.health_comp.max_health)
	player_hp_bar.value = new_hp_percent * player.health_comp.max_health
	player_current_hp_label.text = str(player.health_comp.current_health)
	
	#Gray out the HP to make it known you cant take damage
	health_container.modulate = Color(Color.GRAY, 0.5)
	await get_tree().create_timer(player.health_comp.invuln_time).timeout
	health_container.modulate = Color.WHITE
	pass
