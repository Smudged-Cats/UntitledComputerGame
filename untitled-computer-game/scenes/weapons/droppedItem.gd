extends Area2D
@onready 
var pickedUp = false

@onready 
var canPickup = false

@onready
var playerCharacter = get_parent().get_node("Entities").get_node("Player").get_node("Character")

func _process(delta: float) -> void:
		
	# Moving bomb with player
	if pickedUp:
		self.global_position = Vector2(playerCharacter.global_position)
		
	# Picking up bomb / dropping
	if canPickup:
		if Input.is_action_just_pressed("interact"):
			if pickedUp == false:
				pickedUp = true
			elif pickedUp:
				pickedUp = false

func _on_body_entered(body: Node2D) -> void:
	canPickup = true


func _on_body_exited(body: Node2D) -> void:
	canPickup = false
