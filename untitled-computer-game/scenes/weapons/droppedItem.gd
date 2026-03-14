extends Area2D
class_name DroppedItem

@onready 
var pickedUp = false

@onready 
var canPickup = false

@onready
var playerCharacter = get_parent().get_node("Entities").get_node("Player").get_node("Character")

var weapon: WeaponStats = WeaponStats.new(
	0.01,
	ProjectileStats.new(50,500)
)
func _process(delta: float) -> void:
		
	# Moving bomb with player
	if pickedUp:
		self.global_position = Vector2(playerCharacter.global_position)
		
	# Picking up bomb / dropping
	if canPickup:
		if Input.is_action_just_pressed("interact"):
			if pickedUp == false:
				pickedUp = true
				playerCharacter.get_parent().pickUpWeapon(weapon)
			elif pickedUp:
				pickedUp = false

func _on_body_entered(body: Node2D) -> void:
	if (body is Character):
		canPickup = true


func _on_body_exited(body: Node2D) -> void:
	canPickup = false
