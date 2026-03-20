extends Area2D
class_name DroppedItem

@export
var itemType: String = ""

signal pickUp()

@onready 
var pickedUp = false

@onready 
var canPickup = false

#@onready
#var playerCharacter = get_parent().get_node("Player").get_node("Character")

var item

func _ready() -> void:
	if (itemType == "Weapon"):
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
		item = MeleeStats.new(randf_range(25,50), randf_range(0.1, 0.5))
		
	elif (itemType == "Modifier"):
		item = Modifier.new(
			{"fireRate":0.3,"projectileCount":1,"spread":0.35},
			{"damage":1.0}
			)




#func _process(delta: float) -> void:
		#
	## Moving bomb with player
	#if pickedUp:
		#self.global_position = Vector2(playerCharacter.global_position)
		#
	## Picking up bomb / dropping
	#if canPickup:
		#if Input.is_action_just_pressed("interact"):
			#if pickedUp == false:
				#pickedUp = true
				#playerCharacter.get_parent().pickUpWeapon(weapon)
			#elif pickedUp:
				#pickedUp = false
#

func _on_body_entered(body: Node2D) -> void:
	if (body is Character):
		canPickup = true


func _on_body_exited(body: Node2D) -> void:
	canPickup = false
	
func setWeaponType(type: String):
	self.itemType = type
