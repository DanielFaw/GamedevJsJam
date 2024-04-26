extends Node2D
class_name Door

@onready var sprite : Sprite2D = $Sprite2D
@onready var body : StaticBody2D = $StaticBody2D
@onready var col : CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	#sprite.visible = false
	#col.disabled = true
	#await get_tree().create_timer(2).timeout
	close()
	#await get_tree().create_timer(2).timeout
	#open()
	pass

func open() -> void:
	for i in range(3):
		await get_tree().create_timer(0.2).timeout
		sprite.frame += 1
		pass
	col.disabled = true
	
	await get_tree().create_timer(5).timeout
	sprite.visible = false
	pass

func close() -> void:
	sprite.visible = true
	col.disabled = false
	pass



func _on_area_2d_body_entered(body : Node2D) -> void:
	open()
	pass # Replace with function body.


func _on_area_2d_body_exited(body : Node2D) -> void:
	close()
	pass # Replace with function body.
