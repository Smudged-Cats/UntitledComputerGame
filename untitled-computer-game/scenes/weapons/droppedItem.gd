extends Area2D
class_name DroppedItem

@export
var itemType: String = ""

signal pickUp()


var t = 0

static var newDroppedID = 0
var id = 0

@onready 
var pickedUp = false

@onready 
var canPickup = false

static var usbSprite = preload("res://art/largerUSB.png")

static var meleeLegendarySprite = preload("res://art/weapon sprites/legendary.png")

# Blue area weapons sprites
static var blueRanged1Sprite = preload("res://art/weapon sprites/blue/blue_range1.png")
static var blueRanged2Sprite = preload("res://art/weapon sprites/blue/blue_range2.png")
static var blueMelee1Sprite = preload("res://art/weapon sprites/blue/blue_melee1.png")
#static var blueMelee2Sprite = preload("")

# Red area weapons sprites
static var redRanged1Sprite = preload("res://art/weapon sprites/red/red_range1.png")
#static var redMelee2Sprite = preload("")
static var redMelee1Sprite = preload("res://art/weapon sprites/red/red_melee1.png")
static var redRanged2Sprite = preload("res://art/weapon sprites/red/flamethrower.png")

# Green area weapons sprites
static var greenRanged1Sprite = preload("res://art/weapon sprites/green/green_range1.png")
static var greenRanged2Sprite = preload("res://art/weapon sprites/green/green_range2.png")
static var greenMelee1Sprite = preload("res://art/weapon sprites/green/green_melee1.png")
static var greenMelee2Sprite = preload("res://art/weapon sprites/green/green_melee2.png")


static var RGBSword3DModel = preload("res://rgb_sword.tscn")
static var fireSword3DModel = preload("res://flaming_sword.tscn")
static var electricSythe3DModel = preload("res://electric_sythe.tscn")
static var circuitboardBlasterHammer3DModel = preload("res://green_hammer.tscn")

static var electricBlaster3DModel = preload("res://electricity_blaster.tscn")
static var flamethrower3DModel = preload("res://wex_flamerthrower.tscn")
static var circuitboardBlaster3DModel = preload("res://cd_thommy_gun.tscn")




static var modifier3DModel = preload("res://folder_modifier.tscn")

static var bomb3DModel = preload("res://usb_item.tscn")

#@onready
#var playerCharacter = get_parent().get_node("Player").get_node("Character")

var item

func _ready() -> void:
	get_node("PickupPrompt").visible = false
	self.id = newDroppedID
	newDroppedID += 1
	$SubViewportContainer/SubViewport/Camera3D.global_position.x += self.id * 10
	$SubViewportContainer/SubViewport/ModelRoot.global_position.x += self.id * 10
	
	$SubViewportContainer/SubViewport/Camera3D.global_position.y += 10
	$SubViewportContainer/SubViewport/ModelRoot.global_position.y += 10
	
	
	if (itemType == "Weapon"):
		item = ranGun()
		setWeaponType("Weapon")
	elif (itemType == "Melee"):
		item = ranMelee()
		setWeaponType("Melee")
	elif (itemType == "Modifier"):
		item = ranMod()
		setWeaponType("Modifier")
	elif (itemType == "Bomb"):
		item = bombStats()
		setWeaponType("Bomb")


func _process(delta: float) -> void:
	$SubViewportContainer/SubViewport/ModelRoot.rotate_y(1*delta)
	$SubViewportContainer/SubViewport/ModelRoot.global_position.z = sin(t)
	t+= delta


func _on_body_entered(body: Node2D) -> void:
	if (body is Character):
		get_node("PickupPrompt").visible = true
		canPickup = true


func _on_body_exited(body: Node2D) -> void:
	if (body is Character):
		get_node("PickupPrompt").visible = false
		canPickup = false

func ranGun() -> WeaponStats:
	var weaponToGive: WeaponStats
	if (Player.instance.playerLevel <= 1):
		# Electric Bolts
		weaponToGive = ranTypeOfGun("bolt")
		
	elif (Player.instance.playerLevel == 2):
		# FlameThrower
		weaponToGive = ranTypeOfGun("flamethrower2")
		
	elif (Player.instance.playerLevel == 3):
		# Circuit SMG
		weaponToGive = ranTypeOfGun("smg")
		
	return weaponToGive

#Method for easily getting a specific gun type
func ranTypeOfGun(gunType:String) -> WeaponStats:
	gunType = gunType.to_lower()
	var gunDict: Dictionary = {
		"smg": 
			WeaponStats.new(
			randf_range(0.07,0.2),
			0.02,
			ProjectileStats.new(randi_range(20,50),1000,1,0,1),
			randi_range(0,1),
			1,
			randi_range(25,31)
			),
		"flamethrower":
			WeaponStats.new(
			randf_range(0.01,0.02),#randf_range(0.1,0.2),
			randf_range(0.45,0.6),#randf_range(0.5,0.75),
			ProjectileStats.new(6,450,1,0,2),
			randi_range(0,1),
			1,#randi_range(5,10),
			300
			),
		"bolt":
			WeaponStats.new(
			randf_range(0.8,1.3),
			0.001,
			ProjectileStats.new(randf_range(75,90),1000,3,0,0),
			randi_range(0,1),
			1,
			randi_range(10,15)
			),
		"shotgun":
			WeaponStats.new(
				randf_range(0.7,1.2),
				randf_range(0.6,0.9),
				ProjectileStats.new(randf_range(8,10),700,1,0,1),
				0,
				randi_range(6,8),
				randi_range(50,100)
				),
		"flamethrower2":
			WeaponStats.new(
			randf_range(0.05,0.1),
			randf_range(0.5,0.75),
			ProjectileStats.new(6,700,1,0,2),
			randi_range(0,1),
			randi_range(10,20),
			300
			)
	}
	if (gunDict.has(gunType)):
		return gunDict[gunType]
	else:
		return gunDict[gunDict.keys().pick_random()]

func ranMelee() -> MeleeStats:
	if (Player.instance.playerLevel <= 1):
		return MeleeStats.new(randf_range(25,50), randf_range(0.1, 0.5), 1)
	if (Player.instance.playerLevel == 2):
		return MeleeStats.new(randf_range(50,75), randf_range(0.1, 0.5), 2)
	if (Player.instance.playerLevel == 3):
		return MeleeStats.new(randf_range(75,100), randf_range(0.1, 0.5), 0)
	return MeleeStats.new(randf_range(25,50), randf_range(0.1, 0.5), 1)

	
func bombStats() -> MeleeStats:
		return MeleeStats.new(0, 0, -1)

func ranMod() -> Modifier:
	var weaponStats: WeaponStats = WeaponStats.new(
		0,
		0,
		null,
		-1
	)
	#Remove visual components from the boost dictionary
	weaponStats.stats.erase("3DModel")
	weaponStats.stats.erase("Sprite")
	
	var projectileStats: ProjectileStats = ProjectileStats.new(
		0,
		0,
	)
	
	var meleeStats: MeleeStats = MeleeStats.new(
		0,
		0,
		-1
	)
	#Remove visual components from the boost dictionary
	meleeStats.stats.erase("3DModel")
	meleeStats.stats.erase("Sprite")
	
	return Modifier.new(
		genModDict(weaponStats.stats),
		genModDict(projectileStats.stats),
		genModDict(meleeStats.stats)
	)	

func genModDict(itemStats:Dictionary) -> Dictionary:
	var itemDict: Dictionary = {}
	for stat in itemStats.keys():
		itemDict[stat] = randi_range(-1,5);
		if (itemDict[stat] <= 0):
			itemDict[stat] = 0
	return itemDict

func setWeaponType(type: String):
	self.itemType = type
	if not is_node_ready():
		await ready 
	if type == "Melee":
		if Player.instance.playerLevel == 0:
			item.stats["3DModel"] = 2
		if Player.instance.playerLevel == 1:
			item.stats["3DModel"] = 2
		if Player.instance.playerLevel == 2:
			item.stats["3DModel"] = 1
		if Player.instance.playerLevel == 3:
			item.stats["3DModel"] = 3
		setMeleeModel(item)
	if type == "Weapon":
		if Player.instance.playerLevel == 0:
			item.stats["3DModel"] = 1
		if Player.instance.playerLevel == 1:
			item.stats["3DModel"] = 1
		if Player.instance.playerLevel == 2:
			item.stats["3DModel"] = 2
		if Player.instance.playerLevel == 3:
			item.stats["3DModel"] = 0
		setRangedModel(item)
	if type == "Modifier":
		var newModel = modifier3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)
	if type == "Bomb":
		item.stats["Sprite"] = usbSprite
		var newModel = bomb3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)


# for now, this also sets the sprite, but this should be moved elsewhere when
# a weapon list has been created with established numbers for each weapon
func setMeleeModel(item):
	if item.stats["3DModel"] == 0:
		item.stats["Sprite"] = meleeLegendarySprite
		var newModel = RGBSword3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)
	if item.stats["3DModel"] == 1:
		item.stats["Sprite"] = redMelee1Sprite
		var newModel = fireSword3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)
	if item.stats["3DModel"] == 2:
		item.stats["Sprite"] = blueMelee1Sprite
		var newModel = electricSythe3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)
	if item.stats["3DModel"] == 3:
		item.stats["Sprite"] = greenMelee2Sprite
		var newModel = circuitboardBlasterHammer3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)
		
# for now, this also sets the sprite, but this should be moved elsewhere when
# a weapon list has been created with established numbers for each weapon
func setRangedModel(item):
	if item.stats["3DModel"] == 0:
		item.stats["Sprite"] = greenRanged2Sprite
		var newModel = circuitboardBlaster3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)
	if item.stats["3DModel"] == 1:
		item.stats["Sprite"] = blueRanged1Sprite
		var newModel = electricBlaster3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)
	if item.stats["3DModel"] == 2:
		item.stats["Sprite"] = redRanged2Sprite
		var newModel = flamethrower3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)

		
		
		
		
		
