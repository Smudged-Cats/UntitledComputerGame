extends CanvasLayer

@onready var btns = [$StartButton, $TutorialButton, $QuitButton]
@onready var btnLoc = 0
var tutorialCompleted = false

func _ready() -> void:
	if Player.instance and Player.instance.playerLevel == 1:
		$StartButton.text = "Start"
		Player.instance.visible = false 
	
	if Player.instance and Player.instance.playerLevel > 1:
		$StartButton.text = "Next level"
	
	_on_start_button_mouse_entered()
	if !tutorialCompleted:
		$TutorialButton.disabled = true
		$TutorialButton.visible = false
		$QuitButton.set_position(Vector2(622, 300))
	
func _init(tutorialCom: bool = false) -> void:
	tutorialCompleted = tutorialCom

func _on_start_button_pressed() -> void:
	if Player.instance:
		Player.instance.visible = true
	if tutorialCompleted:
		
		if Player.instance.playerLevel == 1:
			var gameScene = load("res://proc_gen_map.tscn")
			var newGameScene = gameScene.instantiate()
			get_tree().root.add_child(newGameScene)
			Player.instance.reparent(newGameScene)
			
		if Player.instance.playerLevel == 2:
			var gameScene = load("res://proc_gen_map2.tscn")
			var newGameScene = gameScene.instantiate()
			get_tree().root.add_child(newGameScene)
			Player.instance.reparent(newGameScene)
		
		if Player.instance.playerLevel == 3:
			var gameScene = load("res://proc_gen_map3.tscn")
			var newGameScene = gameScene.instantiate()
			get_tree().root.add_child(newGameScene)
			Player.instance.reparent(newGameScene)
		
		#get_tree().change_scene_to_file("res://proc_gen_map.tscn")
		queue_free()
	else:
		get_tree().change_scene_to_file("res://scenes/maps/testMap.tscn")
		queue_free()
		
func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/testMap.tscn")
	queue_free()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
	
	
func _on_start_button_mouse_entered() -> void:
	activate_buttons(0)
	if btnLoc != 0:
		inactivate_buttons(btnLoc)
	btnLoc = 0

func _on_tutorial_button_mouse_entered() -> void:
	activate_buttons(1)
	if btnLoc != 1:
		inactivate_buttons(btnLoc)
	btnLoc = 1

func _on_quit_button_mouse_entered() -> void:
	activate_buttons(2)
	if btnLoc != 2:
		inactivate_buttons(btnLoc)
	btnLoc = 2


func activate_buttons(index: int) -> void:
	btns[index].pivot_offset = btns[index].size / 2
	btns[index].scale = Vector2(1.1, 1.1)
	btns[index].modulate = Color(1.2, 0.0, 0.085, 1.0)
	
func inactivate_buttons(prevIndex: int) -> void:
	btns[prevIndex].scale = Vector2(1, 1)
	btns[prevIndex].modulate = Color(1, 1, 1, 1)

func _input(event: InputEvent) -> void:
	var btnChange = 1
	if !tutorialCompleted:
		btnChange = 2
	inactivate_buttons(btnLoc)
	if Input.is_action_just_pressed("move_down") and btnLoc < 2:
		btnLoc += btnChange
	if Input.is_action_just_pressed("move_up") and btnLoc > 0:
		btnLoc -= btnChange
	eh()
	
	if Input.is_action_just_pressed("enter"):
		if btnLoc == 0:
			_on_start_button_pressed()
		elif btnLoc == 1:
			_on_tutorial_button_pressed()
		else:
			_on_quit_button_pressed()
		
func eh():
	if btnLoc == 0:
		_on_start_button_mouse_entered()
	elif btnLoc == 1:
		_on_tutorial_button_mouse_entered()
	else:
		_on_quit_button_mouse_entered()
