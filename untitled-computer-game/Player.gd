extends Node2D
class_name Player

@onready var hitboxScene = preload("res://scenes/radialHitbox.tscn")

const CAMERA_CHASE_SPEED: float = 3.0

var _character: Character
var _camera: Camera2D
var _hud: Hud

func _ready() -> void:
	_camera = get_node("Camera2D")
	_character = get_node("Character")
	
	_camera.global_position = _character.global_position
	print("Started player")

func _physics_process(delta: float) -> void:
	move_character()
	face_to_mouse()
	listen_for_attack()
	update_camera_position(delta)

func face_to_mouse() -> void:
	# get_global_mouse_position returns the mouse position relative to the player (not the character)
	var worldMousePos = get_global_mouse_position() - self._character.global_position
	_character.look_in_direction(worldMousePos)

func update_camera_position(delta: float) -> void:
	if !is_instance_valid(_camera):
		return
	
	_camera.global_position = _camera.global_position.lerp(
		_character.global_position,
		CAMERA_CHASE_SPEED * delta
	)


func move_character() -> void:
	if !is_instance_valid(_character): return
	var move_dir: Vector2 = get_move_input() * Vector2(1, 0.5)
	_character.set_move_dir(move_dir)

func get_move_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func get_character() -> Character:
	return _character

# The following is a quick hack for our prototype. 
# These functions allow the player to spawn a damage hitbox on left mouse click
func listen_for_attack() -> void:
	if Input.is_action_just_pressed("debug_spawn_hitbox"):
		create_hitbox()

func create_hitbox() -> void:
	var newHitbox = hitboxScene.instantiate();
	newHitbox.set_attacker(_character)
	newHitbox.global_position = self._character.position
	add_child(newHitbox)
	
