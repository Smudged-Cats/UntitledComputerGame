extends Node2D

@onready var enemySpawner = preload("res://scenes/enemySpawner.tscn")
@onready var enemyTSCN = preload("res://scenes/controllers/enemy.tscn")
@onready var droppedItem = preload("res://scenes/weapons/droppedItem.tscn")


var objectiveStarted = false
var hasCreatedSpawner = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var testMapRoom = Room.new(Vector2i(-2,6), Vector2i(8,6))
	spawnEnemiesInRoom(
		Room.new(
			Vector2i(-2,6), # position
			Vector2i(8, 6) # size
			)
		)
	spawnRoomLoot(
		Room.new(
			Vector2i(-2,6), # position
			Vector2i(8, 6) # size
			)
		)
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
	var numberRoomEnemies = randi_range(1,10)
	for i in range(numberRoomEnemies):
		var randomLocation = Vector2i(randi_range(room.p.x, room.p.x + room.s.x), randi_range(room.p.y, room.p.y + room.s.y))
		if ($TileMapScene/Region1Tiles/Tiles.get_cell_source_id(randomLocation) != -1):
			var newEnemy = enemyTSCN.instantiate()
			var pixelPos = $TileMapScene/Region1Tiles/Tiles.map_to_local(randomLocation)
			newEnemy.position = pixelPos
			add_child(newEnemy)
		
func spawnRoomLoot(room: Room):
	var weaponTypes = ["Weapon", "Melee", "Modifier"]
	var randomLootNumber = randi_range(0,2)
	for i in range(randomLootNumber):
		var randomLocation = Vector2i(randi_range(room.p.x, room.p.x + room.s.x), randi_range(room.p.y, room.p.y + room.s.y))
		if ($TileMapScene/Region1Tiles/Tiles.get_cell_source_id(randomLocation) != -1):
			var newDroppedItem = droppedItem.instantiate()
			newDroppedItem.setWeaponType(weaponTypes[randi_range(1,2)])
			var pixelPos = $TileMapScene/Region1Tiles/Tiles.map_to_local(randomLocation)
			newDroppedItem.position = pixelPos
			add_child(newDroppedItem)
	
	
