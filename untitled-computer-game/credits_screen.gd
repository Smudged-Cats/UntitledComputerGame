extends CanvasLayer

@onready var btns = [$ReturnButton]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# make the buttons look different when moused over
func activate_buttons(index: int) -> void:
	btns[index].pivot_offset = btns[index].size / 2
	btns[index].scale = Vector2(1.1, 1.1)
	btns[index].modulate = Color(1.2, 0.0, 0.085, 1.0)
	
func inactivate_buttons(prevIndex: int) -> void:
	btns[prevIndex].scale = Vector2(1, 1)
	btns[prevIndex].modulate = Color(1, 1, 1, 1)

func _on_return_button_pressed() -> void:
	queue_free()

func _on_return_button_mouse_entered() -> void:
	activate_buttons(0)

func _on_return_button_mouse_exited() -> void:
	inactivate_buttons(0)
