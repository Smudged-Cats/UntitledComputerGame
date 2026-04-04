extends Node2D
class_name Player

# Singleton class, because there can only be one player
static var instance: Player

signal picked_up_item(item: DroppedItem)

static var droppedItemScene = preload("res://scenes/weapons/droppedItem.tscn")
static var deathScreenScene = preload("res://scenes/ui/death_screen.tscn")
static var pauseScreenScene = preload("res://scenes/ui/pause_screen.tscn")

var redBar = preload("res://art/weapon sprites/redBar.png")
var blueBar = preload("res://art/weapon sprites/blueBar.png")
var greenBar = preload("res://art/weapon sprites/greenBar.png")
var rainbowBar = preload("res://art/weapon sprites/rainbowBar.png")
var whiteBar = preload("res://art/weapon sprites/whiteBar.png")

@onready var pickupSFX = preload("res://resources/sfx/Pick up.mp3")
@onready var pickupdropSFXPlayer = $Camera2D/pickupdropSFX

@onready var swordSelectSFX = preload("res://resources/sfx/Sword sheathing.mp3")
@onready var gunSelectSFX = preload("res://resources/sfx/Gun cocking.mp3")
@onready var selectSFXPlayer = $Camera2D/selectSFX

@onready var dashSFX = preload("res://resources/sfx/Dash.mp3")
@onready var moveSFX = preload("res://resources/sfx/Walking.mp3")
@onready var movementSFXPlayer = $Camera2D/movementSFX

@onready var swordAtkSFX = preload("res://resources/sfx/Sword contact.mp3")
@onready var shootSFXFire = preload("res://resources/sfx/floraphonic-fire-torch-whoosh-2-186586.mp3")
@onready var shootSFXLazer = preload("res://resources/sfx/lzr.mp3")
@onready var attackSFXPlayer = $Camera2D/attackSFX




static var gunSprite = preload("res://art/weapon sprites/blue/blue_range1.png")

static var swordSprite = preload("res://art/weapon sprites/legendary.png")

@onready var playerLevel = 0

var _character: Character
var _weapon: WeaponController #This is here just for quick access to the WeaponController attributes
var _camera: Camera2D
var _hud: Hud
var modList: Array[Modifier] = [null,null,null]
var currMods = 0
const MAX_MODS: int = 3

#Adjust the the updatedSprites so that it works with the 3 null list
var inventory = [null, null, null]
const MAX_ITEMS:int = 3
var selectedItem:int = 0

# Store dropped items that are close enough that they can be picked up
var itemsInProximity = {}

func _ready() -> void:
	Engine.time_scale = 1
	if instance:
		push_error("More than one player instance detected")
		queue_free.call_deferred()
	
	instance = self
	_camera = $Camera2D
	_character = $Character
	
	#Setting the characterName to be the player for the projectile source
	_character.characterName = "Player"
	_weapon = _character.weapon
	_weapon.holder = _character.characterName
	
	print("Started player")

func _physics_process(delta: float) -> void:
	var meleeItem = inventory[selectedItem]
	if meleeItem != null:
		if meleeItem.stats["3DModel"] == 1:
			$Character/MeleeBar.texture_progress = redBar
		if meleeItem.stats["3DModel"] == 2:
			$Character/MeleeBar.texture_progress = blueBar
		if meleeItem.stats["3DModel"] == 3:
			$Character/MeleeBar.texture_progress = greenBar #change this colour
		if meleeItem.stats["3DModel"] == -1:
			$Character/MeleeBar.texture_progress = whiteBar
		if meleeItem.stats["3DModel"] == 0:
			$Character/MeleeBar.texture_progress = rainbowBar
	
	if _character.health > 0:
		if inventory[selectedItem] is WeaponStats:
			$Camera2D/HUD.get_node("PlayerStatus/AmmoCount").text = str(inventory[selectedItem].stats["ammo"]) + "/" + str(inventory[selectedItem].maxAmmo)
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
		listen_for_pause()
		
	else:
		for item in inventory:
			if item != null:
				if item.stats["3DModel"] == -1:
					drop_item()
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
	
func listen_for_pause() -> void:
	var pauseScene = pauseScreenScene.instantiate()
	if Input.is_action_just_pressed("pause"):
		if Engine.time_scale == 0:
			Engine.time_scale = 1
			get_node("CanvasLayer").queue_free()
		else:
			add_child(pauseScene)
			Engine.time_scale = 0

func selectWeapon(selectIndex:int) -> void:
	
	if _character.isWindingUpAttack: return
	
	var currItem = inventory[selectIndex]
	selectedItem = selectIndex
	#Make stats invisible
	$Camera2D/HUD.get_node("PlayerStatus").get_node("WeaponStats").visible = false
	#Make all arrows invisible
	$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Arrow1").visible = false
	$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Arrow2").visible = false
	$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Arrow3").visible = false
	if (currItem != null):
		if (currItem is WeaponStats):
			_weapon.baseWeapon = currItem
			_character.melee.baseMelee = null
			selectSFXPlayer.stream = gunSelectSFX
			selectSFXPlayer.pitch_scale = 1.1
			selectSFXPlayer.play()
		elif (currItem is MeleeStats):
			_weapon.baseWeapon = null
			_character.melee.baseMelee = currItem
			selectSFXPlayer.stream = swordSelectSFX
			selectSFXPlayer.pitch_scale = 1.25
			selectSFXPlayer.play()
	else:
		_weapon.baseWeapon = null
		_character.melee.baseMelee = null
	# Make the arrow point to the right item
	if (currItem != null):
		match selectIndex:
			0:
				$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Arrow3").visible = true
			1:
				$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Arrow2").visible = true
			2:
				$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Arrow1").visible = true
		$Camera2D/HUD.get_node("PlayerStatus").get_node("WeaponStats").visible = true
		updateStatView()
		'''
		if currItem.stats.has("damage") && currItem.stats["damage"] == 0:
			$Camera2D/HUD.get_node("PlayerStatus").get_node("WeaponStats").text = str("USB Stick:\nPlug into Objective Port")
		elif currItem.stats.has("damage"):
			var damage = currItem.stats["damage"]
			$Camera2D/HUD.get_node("PlayerStatus").get_node("WeaponStats").text = "Base Damage: %.3f HP" % [damage]
		elif currItem.stats.has("fireRate"):
			var fire_rate = currItem.stats["fireRate"]
			var proj_count = currItem.stats["projectileCount"]
			$Camera2D/HUD.get_node("PlayerStatus").get_node("WeaponStats").text = "Firerate: %.1f RPM\nProj. Count: %d" % [60*(1/fire_rate), proj_count]
		'''
			
			
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
		movementSFXPlayer.stream = dashSFX
		movementSFXPlayer.pitch_scale = 0.8
		movementSFXPlayer.volume_db = 0.75
		movementSFXPlayer.play(0.1)
		_character.dash()
		_character.dashWindup = 0
	
func registerHit() -> void:
	self._character.velocity = Vector2.ZERO
	
func listenForShot() -> void:
	if Input.is_action_pressed("debug_spawn_hitbox") and _weapon.baseWeapon != null:
		var mousePos: Vector2 = get_global_mouse_position() - _character.global_position
		_weapon.shoot(
			mousePos, 
			_character.global_position,
			inventory[selectedItem].stats["3DModel"]
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
		if (currMods < MAX_MODS):
			var emptyModSpace: int = modList.find(null)
			item.item.applyBoost(self)
			modList[emptyModSpace] = item.item
			currMods += 1
			print("Applied modifications\n",_weapon.weaponMuls.stats,"\n",_weapon.weaponMuls.projectileStats.stats)
		else:
			return
		
	elif item.itemType == "Bomb":
		var meleeStats = item.item
		inventory.set(selectedItem, meleeStats)
		selectWeapon(selectedItem)

	emit_signal("picked_up_item", item)
	
	# remove the dropped item from the world
	pickupdropSFXPlayer.stream = pickupSFX
	pickupdropSFXPlayer.pitch_scale = 1
	pickupdropSFXPlayer.play()
	item.queue_free.call_deferred()
	updateInventorySprites()
	

func drop_item() -> void:
	var placeHolderPlayerLevel = playerLevel
	
	if _character.isWindingUpAttack: return

	
	if len(inventory) == 0 || inventory[selectedItem] == null: return

	var droppedWeapon = inventory.get(selectedItem)
	
	# spawn the dropped item back into the world
	var newDroppedItem = droppedItemScene.instantiate()
	
	newDroppedItem.global_position = _character.global_position
	newDroppedItem.item = droppedWeapon
	
	get_parent().add_child(newDroppedItem)
	pickupdropSFXPlayer.stream = pickupSFX
	pickupdropSFXPlayer.pitch_scale = 0.8
	pickupdropSFXPlayer.play()
	if droppedWeapon.stats.has("damage") && droppedWeapon.stats["damage"] == 0:
		newDroppedItem.itemType = "Bomb"
		newDroppedItem.setWeaponType("Bomb")
		_character.melee.baseMelee = null
	elif droppedWeapon.stats.has("damage"):
		# - 0 = RGB Sword
		# - 1 = Fire Sword
		# - 2 = Electric Sythe
		# - 3 = Circuit Board Hammer
		if playerLevel == 2:
			if newDroppedItem.item.stats["3DModel"] == 2:
				playerLevel = 1
		if playerLevel == 3:
			if newDroppedItem.item.stats["3DModel"] == 2:
				playerLevel = 1
			if newDroppedItem.item.stats["3DModel"] == 3:
				playerLevel = 2
		newDroppedItem.itemType = "Melee"
		newDroppedItem.setWeaponType("Melee")
		_character.melee.baseMelee = null
		playerLevel = placeHolderPlayerLevel
	elif droppedWeapon.stats.has("fireRate"):
		# - 1 = Electric Blaster
		# - 0 = Circuit Board Blaster
		# - 2 = Red Blaster
		# - 3 = Basic Blaster
		if playerLevel == 2:
			if newDroppedItem.item.stats["3DModel"] == 1:
				playerLevel = 1
		if playerLevel == 3:
			if newDroppedItem.item.stats["3DModel"] == 1:
				playerLevel = 1
			if newDroppedItem.item.stats["3DModel"] == 0:
				playerLevel = 2
		newDroppedItem.itemType = "Weapon"
		newDroppedItem.setWeaponType("Weapon")
		_weapon.baseWeapon = null
		playerLevel = placeHolderPlayerLevel

	inventory.set(selectedItem, null)
	get_node("Camera2D").get_node("HUD").get_node("PlayerStatus").get_node("WeaponStats").visible = false
	updateInventorySprites()
	
func dropMod() -> void:
	print(modList)
	if currMods == 0 || modList[selectedItem] == null: return
	print("gurted")
	var modifier = modList[selectedItem]
	modList[selectedItem] = null
	modifier.removeBoost(self)
	
	var newDroppedItem = droppedItemScene.instantiate()
	get_parent().add_child(newDroppedItem)
	
	newDroppedItem.global_position = _character.global_position
	newDroppedItem.itemType = "Modifier"
	newDroppedItem.setWeaponType("Modifier")
	newDroppedItem.item = modifier
	currMods -= 1
	
	
func updateInventorySprites() -> void:
	var inventoryCurrentSize = inventory.size()
	for i in range(inventoryCurrentSize):
		if inventory[inventoryCurrentSize - 1 - i] != null and inventory[inventoryCurrentSize - 1 - i].stats.has("damage"):
			$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot" + str(i + 1)).texture = inventory[inventoryCurrentSize - 1 - i].getSprite()
		elif inventory[inventoryCurrentSize - 1 - i] != null and inventory[inventoryCurrentSize - 1 - i].stats.has("fireRate"):
			$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot" + str(i + 1)).texture = inventory[inventoryCurrentSize - 1 - i].getSprite()
		else:
			$Camera2D/HUD.get_node("PlayerInventory").get_node("GridContainer").get_node("Slot" + str(i + 1)).texture = null


func show_death_screen() -> void:
	var newDeathScreen = deathScreenScene.instantiate()
	add_child(newDeathScreen)

func _on_character_killed() -> void:
	show_death_screen()
	
func activateBombItem() -> bool:
	for item in inventory:
		if item != null:
			if item.stats.has("damage"):
				if item.stats["damage"] == 0:
					get_node("Camera2D").get_node("HUD").get_node("PlayerStatus").get_node("SurvivePrompt").visible = true
					$"../ObjectivePoint/Timer".start()
					
					
					_character.melee.baseMelee = null
					inventory.set(inventory.find(item), null)
					updateInventorySprites()
					return true
	return false
				
				
func updateStatView() -> void:
	var boostLabel: Label = $Camera2D/HUD.get_node("PlayerStatus").get_node("WeaponStats")
	boostLabel.text = ""
	if (_weapon.baseWeapon != null):
		boostLabel.text = "Damage: %.2f\n# of projectiles: %d\nFirerate: %.1f\n\n" % [_weapon.getDamage(), _weapon.getProjectileCount(), 60*(1/_weapon.getFireRate())]
	elif (_character.melee.baseMelee != null):
		boostLabel.text = "Damage: %.2f\n\n" % [_character.melee.getDamage()]
	
	if (modList[selectedItem] != null):
		boostLabel.text += "Mod Boost:\n" + modList[selectedItem].getBoosts()
