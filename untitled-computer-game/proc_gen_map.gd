extends Node2D

@onready var enemySpawner = preload("res://scenes/enemySpawner.tscn")
@onready var enemyTSCN = preload("res://scenes/controllers/enemy.tscn")
@onready var droppedItem = preload("res://scenes/weapons/droppedItem.tscn")

@onready
var tileSet = $Region1Tiles

@onready var tilemap_instance = $Region1Tiles

@onready var gates: TileMapLayer = $Region1Tiles/GateTiles
@onready var tiletops: TileMapLayer = $Region1Tiles/TileTop


@onready
var onObjective = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ObjectivePoint/Timer/Label.visible = false
	
	for room in tileSet.patternsGenerated:
		if (room.isRoom):
			spawnEnemiesInRoom(room)
			spawnRoomLoot(room)
			
	var timeLeft = $ObjectivePoint/Timer.time_left
	var minutesLeft: int = floor(timeLeft / 60.0)
	var secondsLeft: int = fmod(timeLeft, 60.0)
	var timeString: String = "%02d:%02d" % [minutesLeft, secondsLeft]
	
func _process(float) -> void:
	var timeLeft = $ObjectivePoint/Timer.time_left
	var minutesLeft: int = floor(timeLeft / 60.0)
	var secondsLeft: int = fmod(timeLeft, 60.0)
	var timeString: String = "%02d:%02d" % [minutesLeft, secondsLeft]
	if onObjective and Input.is_action_pressed("interact"):
		get_node("Player").activateBombItem()
		changeUSBtile(Vector2(6, 11))
		var newSpawner = enemySpawner.instantiate()
		add_child(newSpawner)
	$ObjectivePoint/Timer/Label.text = timeString


	
func spawnEnemiesInRoom(room: Room):
	var numberRoomEnemies = randi_range(1,4)
	for i in range(numberRoomEnemies):
		var randomLocation = Vector2i(randi_range(room.p.x, room.p.x + room.s.x), randi_range(room.p.y, room.p.y + room.s.y))
		if ($Region1Tiles/Tiles.get_cell_source_id(randomLocation) > 1):
			var newEnemy = enemyTSCN.instantiate()
			var pixelPos = $Region1Tiles/Tiles.map_to_local(randomLocation)
			newEnemy.position = pixelPos
			add_child.call_deferred(newEnemy)

func spawnRoomLoot(room: Room):
	var weaponTypes = ["Weapon", "Melee", "Modifier"]
	var randomLootNumber = randi_range(1,5)
	for i in range(randomLootNumber):
		var randomLocation = Vector2i(randi_range(room.p.x, room.p.x + room.s.x), randi_range(room.p.y, room.p.y + room.s.y))
		if ($Region1Tiles/Tiles.get_cell_source_id(randomLocation) > 1):
			var newDroppedItem = droppedItem.instantiate()
			newDroppedItem.setWeaponType(weaponTypes[randi_range(0,2)])
			var pixelPos = $Region1Tiles/Tiles.map_to_local(randomLocation)
			newDroppedItem.position = pixelPos
			add_child.call_deferred(newDroppedItem)
	
	


func _on_objective_point_body_entered(body: Node2D) -> void:
	onObjective = true


func _on_objective_point_body_exited(body: Node2D) -> void:
	onObjective = false
	
func toggle_gate_state(closed: bool, gateLoc: Array[Vector2i], left: bool) -> void:
	
	var gatesSheet = 7
	if !closed:
		gatesSheet = 6
	
	var i = 0
	if !left:
		i = 2
	
	for gate in gateLoc:
		gates.set_cell(gate, gatesSheet, Vector2(i, 0))
		i += 1
	

func changeUSBtile(pos: Vector2i) -> void:
	var usbSource = 2
	tiletops.set_cell(pos, usbSource, Vector2i(1, 0))
