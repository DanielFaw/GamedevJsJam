extends Control


@onready var player : Player = SceneResources.get_resource("Player")

@export var player_hp_bar : TextureProgressBar
@export var player_current_hp_label : Label
@export var player_max_hp_label : Label

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
	pass
