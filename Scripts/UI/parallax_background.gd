extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse := event as InputEventMouseMotion
		scroll_offset = Vector2(sqrt(mouse.position.x), sqrt(mouse.position.y))
		pass
	pass
