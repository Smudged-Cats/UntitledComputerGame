extends CanvasLayer

@onready var spectatorScene = preload("res://scenes/controllers/spectator.tscn")

var tFade: float = 0
var fading = false

@onready var btns = [$DeathScreen/RestartButton/Label, $DeathScreen/SpectateButton/Label, $MenuButton, $QuitButton]
@onready var btnLoc = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_restart_button_mouse_entered()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if fading:
		$DeathScreen/Tint.color = $DeathScreen/Tint.color.lerp(Color.BLACK, delta)


func _on_fade_timer_timeout() -> void:
	fading = true


func _on_texture_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_spectate_button_pressed() -> void:
	var newSpectator = spectatorScene.instantiate()
	get_tree().get_root().get_node("Node2D").add_child(newSpectator)
	Player.instance.queue_free()
	#newSpectator.make_current()
	queue_free()
	

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu.tscn")


# All of this stuff is code that allows you to navigate the buttons via keys or mouse
func _on_restart_button_mouse_entered() -> void:
	activate_buttons(0)
	if btnLoc != 0:
		inactivate_buttons(btnLoc)
	btnLoc = 0
	
func _on_spectate_button_mouse_entered() -> void:
	activate_buttons(1)
	if btnLoc != 1:
		inactivate_buttons(btnLoc)
	btnLoc = 1

func _on_menu_button_mouse_entered() -> void:
	activate_buttons(2)
	if btnLoc != 2:
		inactivate_buttons(btnLoc)
	btnLoc = 2
	
func _on_quit_button_mouse_entered() -> void:
	activate_buttons(3)
	if btnLoc != 3:
		inactivate_buttons(btnLoc)
	btnLoc = 3

func activate_buttons(index: int) -> void:
	btns[index].pivot_offset = btns[index].size / 2
	btns[index].scale = Vector2(1.1, 1.1)
	btns[index].modulate = Color(1.2, 0.0, 0.085, 1.0)
	
func inactivate_buttons(prevIndex: int) -> void:
	btns[prevIndex].scale = Vector2(1, 1)
	btns[prevIndex].modulate = Color(1, 1, 1, 1)
	
func _input(event: InputEvent) -> void:
	inactivate_buttons(btnLoc)
	if Input.is_action_just_pressed("move_down") and btnLoc < 3:
		btnLoc += 1
	if Input.is_action_just_pressed("move_up") and btnLoc > 0:
		btnLoc -= 1
	eh()
		
	if Input.is_action_just_pressed("enter"):
		if btnLoc == 0:
			_on_texture_button_pressed()
		elif btnLoc == 1:
			_on_spectate_button_pressed()
		elif btnLoc == 2:
			_on_menu_button_pressed()
		else:
			_on_quit_button_pressed()
	
func eh() -> void:
	if btnLoc == 0:
		_on_restart_button_mouse_entered()
	elif btnLoc == 1:
		_on_spectate_button_mouse_entered()
	elif btnLoc == 2:
		_on_menu_button_mouse_entered()
	else:
		_on_quit_button_mouse_entered()
	
