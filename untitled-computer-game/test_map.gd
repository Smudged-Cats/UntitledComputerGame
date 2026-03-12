extends Node2D

@onready var enemySpawner = preload("res://scenes/enemySpawner.tscn")

var objectiveStarted = false
var hasCreatedSpawner = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ObjectivePoint/Timer/Label.visible = false
	
	
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
	var location1 = [Vector2i(1, 5), Vector2i(2, 5)]
	var location2 = [Vector2i(-3, 9), Vector2i(-3, 8)]
	
	var openGates = 7
	var closedGates = 6
	
	var sheet_for_1 = openGates if is_active else closedGates
	var sheet_for_2 = closedGates if is_active else openGates
	
	var i = 0
	for pos in location1:
		$TileMap/GateTiles.set_cell(pos, sheet_for_1, Vector2i(i, 0))
		i += 1
	
	var j = 2
	for pos in location2:
		$TileMap/GateTiles.set_cell(pos, sheet_for_2, Vector2i(j, 0))
		j += 1
