class_name VictoryScreen
extends CanvasLayer

static var instance: VictoryScreen


var tFade: float = 0
var fading = false

@onready var btns = [$VictoryScreen/RestartButton/Label, $QuitButton]
var btnLoc = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if instance:
		push_error("More than one death screen instance detected")
		queue_free.call_deferred()
	instance = self
	
	_on_restart_button_mouse_entered()


func _on_texture_button_pressed() -> void:
	var menuScene = load("res://start_menu.tscn")
	var newMenuScene = menuScene.instantiate()
	newMenuScene.tutorialCompleted = true 
	get_tree().get_root().add_child(newMenuScene)
	get_tree().current_scene = newMenuScene
	self.queue_free()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()


# All of this stuff is code that allows you to navigate the buttons via keys or mouse
func _on_restart_button_mouse_entered() -> void:
	$ClickSFX.play()
	activate_buttons(0)
	if btnLoc != 0:
		inactivate_buttons(btnLoc)
	btnLoc = 0
	
func _on_quit_button_mouse_entered() -> void:
	$ClickSFX.play()
	activate_buttons(1)
	if btnLoc != 1:
		inactivate_buttons(btnLoc)
	btnLoc = 1

func activate_buttons(index: int) -> void:
	btns[index].pivot_offset = btns[index].size / 2
	btns[index].scale = Vector2(1.1, 1.1)
	btns[index].modulate = Color(1.2, 0.0, 0.085, 1.0)
	
func inactivate_buttons(prevIndex: int) -> void:
	btns[prevIndex].scale = Vector2(1, 1)
	btns[prevIndex].modulate = Color(1, 1, 1, 1)
	
func _input(event: InputEvent) -> void:
	inactivate_buttons(btnLoc)
	if Input.is_action_just_pressed("move_down") and btnLoc < 1:
		btnLoc += 1
	if Input.is_action_just_pressed("move_up") and btnLoc > 0:
		btnLoc -= 1
	eh()
		
	if Input.is_action_just_pressed("enter"):
		if btnLoc == 0:
			_on_texture_button_pressed()
		else:
			_on_quit_button_pressed()
	
func eh() -> void:
	if btnLoc == 0:
		_on_restart_button_mouse_entered()
	else:
		_on_quit_button_mouse_entered()
	
