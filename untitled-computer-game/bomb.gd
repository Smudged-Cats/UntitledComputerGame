extends Node2D

@onready 
var pickedUp = false

@onready 
var canPickup = false

@onready 
var onObjective = false

@onready
var isActivated = false

@onready
var playerCharacter = get_parent().get_node("Entities").get_node("Player").get_node("Character")

func _process(delta: float) -> void:
	if onObjective and pickedUp and Input.is_action_just_pressed("interact") and not isActivated:
		activateBomb()
	if pickedUp == true and not isActivated:
		self.global_position = Vector2(playerCharacter.global_position)
	if canPickup == true and not isActivated:
		if Input.is_action_just_pressed("interact"):
			if pickedUp == false:
				pickedUp = true
			elif pickedUp == true:
				pickedUp = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	canPickup = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	canPickup = false
	
func activateBomb() -> void:
	isActivated = true
	pickedUp = false
	canPickup = false
	get_parent().get_node("ObjectivePoint").get_node("Timer").get_node("Label").visible = true
	get_parent().get_node("ObjectivePoint").get_node("Timer").start()
	get_parent().objectiveStarted = true
	
	var map_node = get_parent()
	if map_node.has_method("toggle_gate_state"):
		map_node.toggle_gate_state(true)
		
	$"../StaticBody2D/WallBorder".disabled = true
	$"../StaticBody2D/WallBorder2".disabled = false
	
