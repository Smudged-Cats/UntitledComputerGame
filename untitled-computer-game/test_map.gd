extends Node2D

@onready var enemySpawner = preload("res://scenes/enemySpawner.tscn")
@onready var enemyTSCN = preload("res://scenes/characters/red_character.tscn")

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
	
func spawnEnemiesInRoom(room: Room):
	var numberRoomEnemies = randint_range(1,10)
	for i in range(numberRoomEnemies):
		var randomLocation = Vector2i(randint(room.p, room.p + room.s))
		newEnemy = enemyTSCN.instantiate()
		var pixelPos = map_to_local(randomLocation)
		add_child(newEnemy)
		newEnemy.postion = pixelPos
		add_child(newEnemy)

		
	
	
