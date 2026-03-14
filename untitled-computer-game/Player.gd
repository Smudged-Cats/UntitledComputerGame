extends Node2D
class_name Player

var droppedItemScene = preload("res://scenes/weapons/droppedItem.tscn")

const CAMERA_CHASE_SPEED: float = 3.0

var _character: Character
var _weapon: WeaponController #This is here just for quick access to the WeaponController attributes
var _camera: Camera2D
var _hud: Hud

@onready var inventory = []

# Store dropped items that are close enough that they can be picked up
var itemsInProximity = {}

func _ready() -> void:
	_camera = get_node("Camera2D")
	_character = get_node("Character")
	
	#Setting the characterName to be the player for the projectile source
	_character.characterName = "Player"
	_weapon = WeaponController.new(_character.characterName)
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
	listen_for_pickup_item()
	listen_for_drop_item()
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

func listen_for_pickup_item() -> void:
	if Input.is_action_just_pressed("interact"):
		pickup_item()

func listen_for_drop_item() -> void:
	if Input.is_action_just_pressed("drop"):
		drop_item()

func listForAbility() -> void:
	if Input.is_action_pressed("lunge_attack"):
		if _character._dashWindup < 1:
			_character._dashWindup += 0.05
	if Input.is_action_just_released("lunge_attack"):
		_character.dash()
		_character._dashWindup = 0
	
	
func registerHit() -> void:
	self._character.velocity = Vector2.ZERO
	
func listenForShot() -> void:
	if Input.is_action_pressed("shoot") and _weapon.baseWeapon != null:
		var mousePos: Vector2 = get_global_mouse_position() - _character.global_position
		_weapon.shoot(
			mousePos, 
			_character.global_position
			)

#pickUpWeapon will called whenever the player picks up a weapon
# for now, it's not fully implemented
#func pickUpWeapon(w:WeaponStats) -> void:
	#_weapon.setWeapon(w)
	#inventory.append(w)
	#
#func dropWeapon(i: int) -> void:
	#_weapon.setWeapon(null)
	#inventory.remove_at(i)

# Called when an item comes close to the character
func add_item_to_nearby(area: Area2D) -> void:
	if area is DroppedItem:
		#itemsInProximity.append(area)
		itemsInProximity[area] = true
		print("I COULD pick up this item")

# TODO: Hashmap istead?
func remove_item_from_nearby(area: Area2D) -> void:
	#for i in range(0, len(itemsInProximity)):
		#if itemsInProximity[i] == area:
			#itemsInProximity.remove_at(i)
			#print("I can no longer pick up this item")
	itemsInProximity.erase(area)
	print("I can no longer pick up this item")

# Search through the itemsInProximity list to determine the closest item
func get_closest_dropped_item() -> DroppedItem:
	var closestItem = null
	var closestItemDistance = INF
	for item in itemsInProximity:
		var distance = (item.global_position - self._character.global_position).length()
		if distance < closestItemDistance:
			closestItem = item
			closestItemDistance = distance
	return closestItem

func pickup_item() -> void:
	
	var item = get_closest_dropped_item()
	if item == null: return
	
	var weaponStats = item.weaponStats
	_weapon.setWeapon(weaponStats)
	inventory.append(weaponStats)
	# remove the dropped item from the world
	item.queue_free()

func drop_item() -> void:
	if len(inventory) == 0: return
	var weaponStats = inventory.pop_front()
	_weapon.setWeapon(null)
	# spawn the dropped item back into the world
	var newDroppedItem = droppedItemScene.instantiate()
	get_tree().get_root().get_node("Node2D").get_node("Items").add_child(newDroppedItem)
	newDroppedItem.global_position = _character.global_position
