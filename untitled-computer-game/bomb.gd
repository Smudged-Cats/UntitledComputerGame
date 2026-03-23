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
var playerCharacter = get_parent().get_node("Player").get_node("Character")

func _process(delta: float) -> void:
	
	# Dropping bomb on objective
	if onObjective and pickedUp and Input.is_action_just_pressed("interact") and not isActivated:
		activateBomb()
		$Sprite2D.visible = false
		
	# Moving bomb with player
	if pickedUp and not isActivated:
		self.global_position = Vector2(playerCharacter.global_position)
		
	# Picking up bomb / dropping
	if canPickup and not isActivated:
		if Input.is_action_just_pressed("interact"):
			if pickedUp == false:
				pickedUp = true
			elif pickedUp:
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
	var tilemap_instance = map_node.get_node_or_null("TileMapScene")
	
	tilemap_instance.toggle_gate_state(true, [Vector2i(1, 5), Vector2i(2, 5)] as Array[Vector2i], true)
	tilemap_instance.toggle_gate_state(false, [Vector2i(-3, 9), Vector2i(-3, 8)] as Array[Vector2i], false)
		
