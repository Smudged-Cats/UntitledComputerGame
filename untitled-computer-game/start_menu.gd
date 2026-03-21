extends CanvasLayer

@onready var button = $StartButton
@onready var otherButton = $QuitButton

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	button.scale = Vector2(1.1, 1.1)
	button.modulate = Color(1.2, 0.0, 0.085, 1.0)
	otherButton.scale = Vector2(1, 1)
	otherButton.modulate = Color(1, 1, 1, 1)
	
func _input(event):
	if Input.is_action_just_pressed("move_down") and button == $StartButton:
		_on_quit_button_mouse_entered()
	if Input.is_action_just_pressed("move_up") and button == $QuitButton:
		_on_start_button_mouse_entered()
	if Input.is_action_just_pressed("enter") and button == $StartButton:
		_on_start_button_pressed()
	if Input.is_action_just_pressed("enter") and button == $QuitButton:
		_on_quit_button_pressed()

func _on_start_button_mouse_entered() -> void:
	button = $StartButton
	otherButton = $QuitButton

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://proc_gen_map.tscn")

	
func _on_quit_button_mouse_entered() -> void:
	button = $QuitButton
	otherButton = $StartButton

func _on_quit_button_pressed() -> void:
	get_tree().quit()
