extends CanvasLayer
class_name Hud

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_health_changed(newHealth: int) -> void:
	print(newHealth)
