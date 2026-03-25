extends Node2D
class_name Player

# Singleton class, because there can only be one player
static var instance: Player

var droppedItemScene = preload("res://scenes/weapons/droppedItem.tscn")
var deathScreenScene = preload("res://scenes/ui/death_screen.tscn")

@onready 
var gunSprite = preload("res://art/tiles/pixil-frame-0.png")

@onready 
var swordSprite = preload("res://art/tiles/pixil-frame-0_1.png")

var _character: Character
var _weapon: WeaponController #This is here just for quick access to the WeaponController attributes
var _camera: Camera2D
var _hud: Hud
var modList: Array[Modifier]

#Adjust the the updatedSprites so that it works with the 3 null list
@onready var inventory = [null, null, null]
const MAX_ITEMS:int = 3
var selectedItem:int = 0

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
	listenForNum()
	_camera.update_camera_position(delta)
	
	if Input.is_action_just_pressed("kill me"):
		_character.health = 0
	
	_character.get_node("MeleeBar").value = _character.meleeWindup
	
func listenForNum() -> void:
	if (Input.is_action_just_pressed("1")):
		selectWeapon(0)
	elif (Input.is_action_just_pressed("2")):
		selectWeapon(1)
	elif (Input.is_action_just_pressed("3")):
		selectWeapon(2)
	

func selectWeapon(selectIndex:int) -> void:
	var currItem = inventory[selectIndex]
	print(currItem != null)
	if (currItem != null):
		selectedItem = selectIndex
		if (currItem is WeaponStats):
			_weapon.baseWeapon = currItem
			_character.melee.baseMelee = null
		elif (currItem is MeleeStats):
			_weapon.baseWeapon = null
			_character.melee.baseMelee = currItem
			
			
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
	var emptyIndex: int = inventory.find(null)
	print(emptyIndex)
	
	var item = get_closest_dropped_item()
	if item == null: 
		return
	elif (item.item is MeleeStats):
		var meleeStats = item.item
		if (emptyIndex != -1):
			inventory.set(emptyIndex, meleeStats)
			selectWeapon(emptyIndex)
		else:
			drop_item()
			inventory.set(selectedItem, meleeStats)
			selectWeapon(selectedItem)
		#_character.melee.baseMelee = meleeStats
		#_weapon.baseWeapon = null
	elif (item.item is WeaponStats):
		var weaponStats = item.item
		if (emptyIndex != -1):
			inventory.set(emptyIndex,weaponStats)
			selectWeapon(emptyIndex)
		else:
			drop_item()
			inventory.set(selectedItem,weaponStats)
			selectWeapon(selectedItem)
		#_weapon.setWeapon(weaponStats)
		#inventory.append(weaponStats)
		#_character.melee.baseMelee = null
		print("Picked up weapon\n",_weapon.baseWeapon.stats,"\n",_weapon.baseWeapon.projectileStats.stats)
	elif item.item is Modifier:
		item.item.applyBoost(self)
		modList.append(item.item)
		print("Applied modifications\n",_weapon.weaponMuls.stats,"\n",_weapon.weaponMuls.projectileStats.stats)
		
	elif item.itemType == "Bomb":
		var meleeStats = item.item
		inventory.set(selectedItem, meleeStats)
		selectWeapon(selectedItem)

		
		
		
	# remove the dropped item from the world
	item.queue_free()
	updateInventorySprites()
	

func drop_item() -> void:
	
	if len(inventory) == 0 || inventory[selectedItem] == null: return

	var droppedWeapon = inventory.get(selectedItem)
	#var weaponStats = inventory.pop_back()
	'''
	if len(inventory) == 0:
		_weapon.setWeapon(null)
		_character.melee.baseMelee = null
	elif inventory.back() is not MeleeStats:
		_weapon.setWeapon(inventory.back())
		_character.melee.baseMelee = null
	else:
		_weapon.setWeapon(null)
		_character.melee.baseMelee = inventory.back()
	'''
	
	# spawn the dropped item back into the world
	var newDroppedItem = droppedItemScene.instantiate()
	get_tree().get_root().get_node("Node2D").add_child(newDroppedItem)
	if droppedWeapon.stats.has("damage") && droppedWeapon.stats["damage"] == 0:
		newDroppedItem.itemType = "Bomb"
		newDroppedItem.setWeaponType("Bomb")
		_character.melee.baseMelee = null
	elif droppedWeapon.stats.has("damage"):
		newDroppedItem.itemType = "Melee"
		newDroppedItem.setWeaponType("Melee")
		_character.melee.baseMelee = null
	elif droppedWeapon.stats.has("fireRate"):
		newDroppedItem.itemType = "Weapon"
		newDroppedItem.setWeaponType("Weapon")
		_weapon.baseWeapon = null



	newDroppedItem.global_position = _character.global_position
	newDroppedItem.item = droppedWeapon
	inventory.set(selectedItem,null)
	updateInventorySprites()
	
func dropMod() -> void:
	if len(modList) == 0: return
	
	var modifier = modList.pop_back()
	modifier.removeBoost(self)
	
	var newDroppedItem = droppedItemScene.instantiate()
	get_tree().get_root().get_node("Node2D").add_child(newDroppedItem)
	newDroppedItem.global_position = _character.global_position
	newDroppedItem.itemType = "Modifier"
	newDroppedItem.setWeaponType("Modifier")

	newDroppedItem.item = modifier
	
	
	
func updateInventorySprites() -> void:
	var inventoryCurrentSize = inventory.size()
	for i in range(inventoryCurrentSize):
		if inventory[inventoryCurrentSize - 1 - i] != null and inventory[inventoryCurrentSize - 1 - i].stats.has("damage"):
			$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot" + str(i + 1)).texture = swordSprite
		elif inventory[inventoryCurrentSize - 1 - i] != null and inventory[inventoryCurrentSize - 1 - i].stats.has("fireRate"):
			$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot" + str(i + 1)).texture = gunSprite
	if inventoryCurrentSize == 2:
		$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot3").texture = null
	elif inventoryCurrentSize == 1:
		$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot3").texture = null
		$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot2").texture = null
	elif inventoryCurrentSize == 0:
		$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot3").texture = null
		$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot2").texture = null
		$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot1").texture = null




func show_death_screen() -> void:
	var newDeathScreen = deathScreenScene.instantiate()
	add_child(newDeathScreen)


func _on_character_killed() -> void:
	show_death_screen()
	_character.queue_free()

func addMod():
	modList.append(Modifier.new({"fireRate":0.3},{"damage":1.0}))
	modList.get(modList.size() - 1).applyBoost(self)
	
func activateBombItem() -> void:
	for item in inventory:
		if item != null:
			if item.stats.has("damage"):
				if item.stats["damage"] == 0:
					$"../ObjectivePoint/Timer/Label".visible = true
					$"../ObjectivePoint/Timer".start()
					var map_node = get_parent()
					var tilemap_instance = map_node.get_node_or_null("TileMapScene")
					
					tilemap_instance.toggle_gate_state(true, [Vector2i(1, 5), Vector2i(2, 5)] as Array[Vector2i], true)
					tilemap_instance.toggle_gate_state(false, [Vector2i(-3, 9), Vector2i(-3, 8)] as Array[Vector2i], false)
						
					_character.melee.baseMelee = null
					inventory.set(selectedItem, null)
					updateInventorySprites()
				
		
