extends Node2D
class_name Player

const CAMERA_CHASE_SPEED: float = 3.0

var _character: Character
var _weapon: WeaponController #This is here just for quick access to the WeaponController attributes
var _camera: Camera2D
var _hud: Hud

func _ready() -> void:
	_camera = get_node("Camera2D")
	_character = get_node("Character")
	
	#Setting the characterName to be the player for the projectile source
	_character.characterName = "Player"
	_weapon = WeaponController.new(_character.characterName, Weapon.new(0.1,21,450))
	add_child(_weapon)
	
	_camera.global_position = _character.global_position
	
	print("Started player")

func _physics_process(delta: float) -> void:
	if get_node("Character").health <= 0:
		print("YOU LOSE!")
		
	move_character()
	face_to_mouse()
	listen_for_attack()
	listenForShot()
	listForAbility()
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
	
	#Using the attackCooldown example here
	if Input.is_action_just_pressed("debug_spawn_hitbox"):
		_character.start_attack_windup()
	elif Input.is_action_just_released("debug_spawn_hitbox"):
		_character.release_attack_windup()

func listForAbility() -> void:
	if Input.is_action_pressed("lunge_attack"):
		if _character._dashWindup < 500:
			_character._dashWindup += 25
	if Input.is_action_just_released("lunge_attack"):
		_character.dash()
		_character._dashWindup = 0
	
	
func registerHit() -> void:
	self._character.velocity = Vector2.ZERO
	
func listenForShot() -> void:
	if Input.is_action_pressed("shoot"):
		var mousePos: Vector2 = get_global_mouse_position() - _character.global_position
		_weapon.shoot(
			mousePos, 
			_character.global_position
			)

#pickUpWeapon will called whenever the player picks up a weapon
# for now, it's not fully implemented
func pickUpWeapon() -> void:
	#_weapon.setWeapon(Weapon.new(0.67,3,50))
	pass
