extends Control


@onready var player : Player = SceneResources.get_resource("Player")

@export var player_hp_bar : TextureProgressBar
@export var player_current_hp_label : Label
@export var player_max_hp_label : Label
@export var health_container : Control

func _ready() -> void:
	player.health_comp.took_damage.connect(player_took_dmg)
	player_max_hp_label.text = str(player.health_comp.max_health)
	player_current_hp_label.text = str(player.health_comp.current_health)
	
	var new_hp_percent : float = player.health_comp.current_health / player.health_comp.max_health
	player_hp_bar.value = new_hp_percent * player.health_comp.max_health
	
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
