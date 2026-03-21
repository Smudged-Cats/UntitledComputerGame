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

@onready 
var meleePlaceholderSprite = preload("res://art/tiles/pixil-frame-0_1.png")

@onready 
var rangedPlaceholderSprite = preload("res://art/tiles/pixil-frame-0.png")

@onready
var melee3DModel = preload("res://rgb_sword.tscn")

@onready
var ranged3DModel = preload("res://electricity_blaster.tscn")

#@onready
#var playerCharacter = get_parent().get_node("Player").get_node("Character")

var item

func _ready() -> void:
	self.id = newDroppedID
	newDroppedID += 1
	$SubViewportContainer/SubViewport/Camera3D.global_position.x += self.id * 10
	$SubViewportContainer/SubViewport/ModelRoot.global_position.x += self.id * 10
	
	$SubViewportContainer/SubViewport/Camera3D.global_position.y += 10
	$SubViewportContainer/SubViewport/ModelRoot.global_position.y += 10
	
	
	if (itemType == "Weapon"):
		setWeaponType("Weapon")
		var ranWeapon = randi_range(1,3)
		if (ranWeapon == 1):
			item = WeaponStats.new(
				randf_range(0.07,0.2),
				0.02,
				ProjectileStats.new(randf_range(8,20),700)
			)
		elif (ranWeapon == 2):
			item = WeaponStats.new(
				randf_range(0.3,0.55),
				randf_range(0.1,0.3),
				ProjectileStats.new(6,700),
				randi_range(5,8)
			)
		elif (ranWeapon == 3):
			item = WeaponStats.new(
				randf_range(0.8,1.3),
				0.001,
				ProjectileStats.new(randi_range(65,90),1000,3)
			)
	elif (itemType == "Melee"):
		setWeaponType("Melee")
		item = MeleeStats.new(randf_range(25,50), randf_range(0.1, 0.5))
		
	elif (itemType == "Modifier"):
		item = Modifier.new(
			{"fireRate":0.3,"projectileCount":1,"spread":0.35},
			{"damage":1.0}
			)




func _process(delta: float) -> void:
	$SubViewportContainer/SubViewport/ModelRoot.rotate_y(1*delta)
	$SubViewportContainer/SubViewport/ModelRoot.global_position.z = sin(t)
	t+= delta




func _on_body_entered(body: Node2D) -> void:
	if (body is Character):
		canPickup = true


func _on_body_exited(body: Node2D) -> void:
	canPickup = false
	
func setWeaponType(type: String):
	self.itemType = type
	if not is_node_ready():
		await ready 
	if type == "Melee":
		var newModel = melee3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)
	if type == "Weapon":
		var newModel = ranged3DModel.instantiate()
		$SubViewportContainer/SubViewport/ModelRoot.add_child(newModel)
