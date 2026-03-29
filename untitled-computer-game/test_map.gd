extends Node2D

@onready var enemySpawner = preload("res://scenes/enemySpawner.tscn")
@onready var enemyTSCN = preload("res://scenes/controllers/enemy.tscn")
@onready var droppedItem = preload("res://scenes/weapons/droppedItem.tscn")
@onready var startMenu = preload("res://start_menu.tscn")
@onready var tilemap_instance = get_node_or_null("TileMapScene")

@onready var onObjective = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#for i in 300:
		#var newEnemy = enemyTSCN.instantiate()
		#newEnemy.position = Vector2i(500+i*10,0)
		#add_child(newEnemy)
	
	#spawnEnemiesInRoom(
		#Room.new(
			#Vector2i(-2,6), # position
			#Vector2i(8, 6), # size
			#false)
		#)
	#spawnRoomLoot(
		#Room.new(
			#Vector2i(-2,6), # position
			#Vector2i(8, 6),# size
			#false 
			#)
		#)
	$ObjectivePoint/Timer/Label.visible = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var timeLeft = $ObjectivePoint/Timer.time_left
	var minutesLeft: int = floor(timeLeft / 60.0)
	var secondsLeft: int = fmod(timeLeft, 60.0)
	var timeString: String = "%02d:%02d" % [minutesLeft, secondsLeft]
	if onObjective and Input.is_action_just_pressed("interact"):
		get_node("Player").activateBombItem()
		tilemap_instance.toggle_gate_state(false, [Vector2i(-3, 9), Vector2i(-3, 8)] as Array[Vector2i], false)
		tilemap_instance.toggle_gate_state(true, [Vector2i(1, 5), Vector2i(2, 5)] as Array[Vector2i], true)

		tilemap_instance.changeUSBtile(Vector2(-4, 13))
		
		for i in range(5):
			var tutorialRoom = Room.new(Vector2i(-4,4), Vector2i(8,8), 1)
			spawnEnemiesInRoom(tutorialRoom)
			await get_tree().create_timer(10).timeout

	if timeLeft < 1 and timeLeft > 0:
		
		var menuScene = load("res://start_menu.tscn")
		var newMenuScene = menuScene.instantiate()
		newMenuScene._init(true)
		get_tree().root.add_child(newMenuScene)
		queue_free()
		
	get_node("Background").global_position = get_node("Player").get_node("Camera2D").global_position
		

	$ObjectivePoint/Timer/Label.text = timeString
func _on_objective_point_body_entered(body: Node2D) -> void:
	onObjective = true
func _on_objective_point_body_exited(body: Node2D) -> void:
	onObjective = false
	
func spawnEnemiesInRoom(room: Room):
	var numberRoomEnemies = 5
	for i in range(numberRoomEnemies):
		var randomLocation = Vector2i(randi_range(room.p.x, room.p.x + room.s.x), randi_range(room.p.y, room.p.y + room.s.y))
		if ($TileMapScene/Region1Tiles/Tiles.get_cell_source_id(randomLocation) != -1):
			var newEnemy = enemyTSCN.instantiate()
			var pixelPos = $TileMapScene/Region1Tiles/Tiles.map_to_local(randomLocation)
			newEnemy.position = pixelPos
			add_child(newEnemy)
		
func spawnRoomLoot(room: Room):
	var weaponTypes = ["Weapon", "Melee", "Modifier"]
	var randomLootNumber = randi_range(1,5)
	for i in range(randomLootNumber):
		var randomLocation = Vector2i(randi_range(room.p.x, room.p.x + room.s.x), randi_range(room.p.y, room.p.y + room.s.y))
		if ($TileMapScene/Region1Tiles/Tiles.get_cell_source_id(randomLocation) != -1):
			var newDroppedItem = droppedItem.instantiate()
			newDroppedItem.setWeaponType(weaponTypes[randi_range(0,2)])
			var pixelPos = $TileMapScene/Region1Tiles/Tiles.map_to_local(randomLocation)
			newDroppedItem.position = pixelPos
			add_child(newDroppedItem)
	
	
