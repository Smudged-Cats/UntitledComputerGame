extends Node2D
class_name Player

# Singleton class, because there can only be one player
static var instance: Player

var droppedItemScene = preload("res://scenes/weapons/droppedItem.tscn")
var deathScreenScene = preload("res://scenes/ui/death_screen.tscn")

var _character: Character
var _weapon: WeaponController #This is here just for quick access to the WeaponController attributes
var _camera: Camera2D
var _hud: Hud
var modList: Array[Modifier]

@onready var inventory = []

# Store dropped items that are close enough that they can be picked up
var itemsInProximity = {}

func _ready() -> void:
	if instance:
		push_error("More than one player instance detected")
		queue_free()
	
	instance = self
	_camera = $Camera2D
	_character = $Character
	
	#Setting the characterName to be the player for the projectile source
	_character.characterName = "Player"
	_weapon = WeaponController.new(_character.characterName)
	add_child(_weapon)
	
	print("Started player")

func _physics_process(delta: float) -> void:
	if len(inventory) > 0 and inventory[len(inventory)-1] is WeaponStats:
		$Camera2D/HUD.get_node("PlayerStatus/AmmoCount").text = str(inventory[len(inventory)-1].stats["ammo"]) + "/20"
		$Camera2D/HUD.get_node("PlayerStatus/AmmoCount").visible = true
	else:
		$Camera2D/HUD.get_node("PlayerStatus/AmmoCount").visible = false
	if !is_instance_valid(_character): return
		
	move_character()
	face_to_mouse(delta)
	listen_for_attack()
	listenForShot()
	listForAbility()
	listen_for_pickup_item()
	listen_for_drop_item()
	listen_for_drop_mod()
	_camera.update_camera_position(delta)
	
	_character.get_node("MeleeBar").value = _character.meleeWindup
	

func face_to_mouse(delta: float = 1) -> void:
	# get_global_mouse_position returns the mouse position relative to the player (not the character)
	var worldMousePos = get_global_mouse_position() - self._character.global_position
	_character.look_in_direction(worldMousePos, delta)

func move_character() -> void:
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
		
func listen_for_drop_mod() -> void:
	if Input.is_action_just_pressed("dropMod"):
		dropMod()

func listForAbility() -> void:
	if Input.is_action_pressed("lunge_attack"):
		if _character.dashWindup < 1:
			_character.dashWindup += 0.05
	if Input.is_action_just_released("lunge_attack"):
		_character.dash()
		_character.dashWindup = 0
	
func registerHit() -> void:
	self._character.velocity = Vector2.ZERO
	
func listenForShot() -> void:
	if Input.is_action_pressed("shoot") and _weapon.baseWeapon != null:
		var mousePos: Vector2 = get_global_mouse_position() - _character.global_position
		_weapon.shoot(
			mousePos, 
			_character.global_position
			)

# Called when an item comes close to the character
func add_item_to_nearby(area: Area2D) -> void:
	if area is DroppedItem:
		itemsInProximity[area] = true

# Called when an item leaves proximity
func remove_item_from_nearby(area: Area2D) -> void:
	itemsInProximity.erase(area)

# Search through the itemsInProximity list to determine the closest item
# TODO: Do we want to pick up the first item we see that is in proximity? Would be faster
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
	if item == null: 
		return
	elif (item.item is MeleeStats):
		var meleeStats = item.item
		inventory.append(meleeStats)
		_character.melee.baseMelee = meleeStats

	elif (item.item is WeaponStats):
		var weaponStats = item.item
		_weapon.setWeapon(weaponStats)
		inventory.append(weaponStats)
		print("Picked up weapon\n",_weapon.baseWeapon.stats,"\n",_weapon.baseWeapon.projectileStats.stats)
	elif item.item is Modifier:
		item.item.applyBoost(self)
		modList.append(item.item)
		print("Applied modifications\n",_weapon.weaponMuls.stats,"\n",_weapon.weaponMuls.projectileStats.stats)
		
	# remove the dropped item from the world
	item.queue_free()
	

func drop_item() -> void:
	
	if len(inventory) == 0: return

	var droppedWeapon = inventory.back()
	var weaponStats = inventory.pop_back()

	if len(inventory) == 0:
		_weapon.setWeapon(null)
	elif inventory.back() is not MeleeStats:
		_weapon.setWeapon(inventory.back())
	else:
		_weapon.setWeapon(null)

		
		
	# spawn the dropped item back into the world
	var newDroppedItem = droppedItemScene.instantiate()
	get_tree().get_root().get_node("Node2D").add_child(newDroppedItem)
	if droppedWeapon.stats.has("damage"):
		newDroppedItem.itemType = "Melee"
		newDroppedItem.setWeaponType("Melee")
	elif droppedWeapon.stats.has("fireRate"):
		newDroppedItem.itemType = "Weapon"
		newDroppedItem.setWeaponType("Weapon")
	newDroppedItem.global_position = _character.global_position
	newDroppedItem.item = weaponStats
	
func dropMod() -> void:
	if len(modList) == 0: return
	
	var modifier = modList.pop_back()
	modifier.removeBoost(self)
	
	var newDroppedItem = droppedItemScene.instantiate()
	get_tree().get_root().get_node("Node2D").add_child(newDroppedItem)
	newDroppedItem.global_position = _character.global_position
	newDroppedItem.itemType = "Modifier"
	newDroppedItem.item = modifier

func show_death_screen() -> void:
	var newDeathScreen = deathScreenScene.instantiate()
	add_child(newDeathScreen)


func _on_character_killed() -> void:
	show_death_screen()
	_character.queue_free()

func addMod():
	modList.append(Modifier.new({"fireRate":0.3},{"damage":1.0}))
	modList.get(modList.size() - 1).applyBoost(self)
