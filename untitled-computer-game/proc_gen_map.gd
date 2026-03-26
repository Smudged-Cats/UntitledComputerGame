extends Node2D

@onready var enemySpawner = preload("res://scenes/enemySpawner.tscn")
@onready var enemyTSCN = preload("res://scenes/controllers/enemy.tscn")
@onready var droppedItem = preload("res://scenes/weapons/droppedItem.tscn")

@onready
var tileSet = $Region1Tiles


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for room in tileSet.patternsGenerated:
		if (room.isRoom):
			spawnEnemiesInRoom(room)
			spawnRoomLoot(room)

	
func spawnEnemiesInRoom(room: Room):
	var numberRoomEnemies = randi_range(1,4)
	for i in range(numberRoomEnemies):
		var randomLocation = Vector2i(randi_range(room.p.x, room.p.x + room.s.x), randi_range(room.p.y, room.p.y + room.s.y))
		if ($Region1Tiles/Tiles.get_cell_source_id(randomLocation) > 1):
			var newEnemy = enemyTSCN.instantiate()
			var pixelPos = $Region1Tiles/Tiles.map_to_local(randomLocation)
			newEnemy.position = pixelPos
			add_child(newEnemy)
		
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
			add_child(newDroppedItem)
	
	
