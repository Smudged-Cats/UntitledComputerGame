extends Node2D

@onready var enemySpawner = preload("res://scenes/enemySpawner.tscn")

var objectiveStarted = false
var hasCreatedSpawner = false

# Seperate gates into those that run along the X vs the Y axis
var gatesAlongX = []
var gatesAlongY = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ObjectivePoint/Timer/Label.visible = false
	
	# hard-coded positions for the pre-placed gates in testMap
	var gates1 = [Vector2i(1, 5), Vector2i(2, 5)]
	var gates2 = [Vector2i(-3, 9), Vector2i(-3, 8)]
	gatesAlongX.append(gates1)
	gatesAlongY.append(gates2)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var timeLeft = $ObjectivePoint/Timer.time_left
	var minutesLeft: int = floor(timeLeft / 60.0)
	var secondsLeft: int = fmod(timeLeft, 60.0)
	var timeString: String = "%02d:%02d" % [minutesLeft, secondsLeft]
	
	
	if timeLeft <= 0 and objectiveStarted:
		print("Explosion")
	elif objectiveStarted and timeLeft > 0 and !hasCreatedSpawner:
		var newSpawner = enemySpawner.instantiate()
		add_child(newSpawner)
		newSpawner.global_position = Vector2(200,100)
		hasCreatedSpawner = true
		

	$ObjectivePoint/Timer/Label.text = timeString
func _on_objective_point_body_entered(body: Node2D) -> void:
	$Bomb.onObjective = true

func _on_objective_point_body_exited(body: Node2D) -> void:
	$Bomb.onObjective = false
	

func toggle_gate_state(is_active:bool) -> void:
	
	# Atlas texture position for open and closed gates
	var openGates = 7
	var closedGates = 6
	
	# Get the gate textures from the texture positions
	var sheet_for_1 = openGates if is_active else closedGates
	var sheet_for_2 = closedGates if is_active else openGates
	
	for gate in gatesAlongX:
		var i = 0
		for pos in gate:
			$TileMap/GateTiles.set_cell(pos, sheet_for_1, Vector2i(i, 0))
			i += 1
	
	for gate in gatesAlongY:
		var j = 2
		for pos in gate:
			$TileMap/GateTiles.set_cell(pos, sheet_for_2, Vector2i(j, 0))
			j += 1
