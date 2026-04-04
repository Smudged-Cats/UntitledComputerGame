extends Node2D

@onready var enemySpawner = preload("res://scenes/enemySpawner.tscn")
@onready var enemyTSCN = preload("res://scenes/controllers/enemy.tscn")
@onready var droppedItem = preload("res://scenes/weapons/droppedItem.tscn")

@onready var lvl1Music = preload("res://art/Music/roman_sol-smooth-menu-background-449731.mp3")
@onready var lvl2Music = preload("res://art/Music/hitslab-dramatic-serious-intense-music-406394.mp3")
@onready var lvl3Music = preload("res://art/Music/denis-pavlov-music-magical-technology-sci-fi-science-futuristic-game-music-300607.mp3")

@onready var endGameScreen = preload("res://VictoryScreen.tscn")

@onready"res://VictoryScreen.tscn"
var tileSet = $Region1Tiles

@onready var tilemap_instance = $Region1Tiles

@onready var gates: TileMapLayer = $Region1Tiles/GateTiles
@onready var tiletops: TileMapLayer = $Region1Tiles/TileTop

@onready var enemySpawnSprite = preload("res://art/AntiBugSymbol.png")

@onready
var onObjective = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	get_node("Level Music").play()
	for room in tileSet.patternsGenerated:
		if (room.isRoom):
			spawnEnemiesInRoom(room)
			spawnRoomLoot(room)
	
	
	for item in Player.instance.inventory:
		if item != null:
			if item.stats.has("ammo"):
				item.stats["ammo"] = item.maxAmmo
	
	
func _process(float) -> void:
	if Player.instance == null:
		get_node("Background").global_position = SpectatorCamera.instance.global_position
		get_node("Background").scale = Vector2.ONE * 2.5 / SpectatorCamera.instance.zoom.x
	else:
		get_node("Background").global_position = Player.instance._camera.global_position
		var timeLeft = $ObjectivePoint/Timer.time_left
		var minutesLeft: int = floor(timeLeft / 60.0)
		var secondsLeft: int = fmod(timeLeft, 60.0)
		var timeString: String = "%02d:%02d" % [minutesLeft, secondsLeft]
		get_node("Player").get_node("Camera2D").get_node("HUD").get_node("PlayerStatus").get_node("SurvivePrompt").text = str("SURVIVE: " + timeString)
		if timeLeft < 10 and timeLeft > 9:
			$Beeping.play()
		if timeLeft < 1 and timeLeft > 0:
			if Player.instance.playerLevel == 3:
				get_node("Player").get_node("Camera2D").get_node("HUD").get_node("PlayerStatus").get_node("SurvivePrompt").visible = false
				get_tree().paused = true
				Player.instance.get_node("Camera2D").get_node("HUD").get_node("GlitchEffectCanvasLayer").visible = true
				Player.instance.get_node("Camera2D").get_node("BugLaughingSFX").play()
				await get_tree().create_timer(5.0, true).timeout
				get_tree().paused = false
				Player.instance.get_node("Camera2D").get_node("HUD").get_node("GlitchEffectCanvasLayer").visible = false
				var newMenuScene = endGameScreen.instantiate()
				get_tree().root.add_child(newMenuScene)
				queue_free()
			else:
				get_node("Player").get_node("Camera2D").get_node("HUD").get_node("PlayerStatus").get_node("SurvivePrompt").visible = false
				get_node("Player").playerLevel += 1
				get_tree().paused = true
				Player.instance.get_node("Camera2D").get_node("HUD").get_node("GlitchEffectCanvasLayer").visible = true
				Player.instance.get_node("Camera2D").get_node("BugLaughingSFX").play()
				await get_tree().create_timer(5.0, true).timeout
				get_tree().paused = false
				Player.instance.get_node("Camera2D").get_node("HUD").get_node("GlitchEffectCanvasLayer").visible = false
				var menuScene = load("res://start_menu.tscn")
				var newMenuScene = menuScene.instantiate()
				newMenuScene._init(true)
				get_tree().root.add_child(newMenuScene)
				get_node("Player").reparent(newMenuScene)
				queue_free()		
		
		
	if onObjective and Input.is_action_just_pressed("interact"):
		if get_node("Player").activateBombItem():
			if get_node("Player").playerLevel == 1:
				toggle_gate_state(false, [Vector2i(12, 4), Vector2i(13, 4)] as Array[Vector2i], true)
				toggle_gate_state(false, [Vector2i(12, -7), Vector2i(13, -7)] as Array[Vector2i], true)
				toggle_gate_state(false, [Vector2i(17, -1), Vector2i(17, -2)] as Array[Vector2i], false)
				toggle_gate_state(false, [Vector2i(6, -1), Vector2i(6, -2)] as Array[Vector2i], false)
			
			if get_node("Player").playerLevel == 3:
				toggle_gate_state(false, [Vector2i(4, 16), Vector2i(4, 17)] as Array[Vector2i], true)
				toggle_gate_state(false, [Vector2i(9, 5), Vector2i(10, 6)] as Array[Vector2i], true)
				toggle_gate_state(false, [Vector2i(9, 16), Vector2i(9, 15)] as Array[Vector2i], false)
				toggle_gate_state(false, [Vector2i(3, 5), Vector2i(4, 4)] as Array[Vector2i], false)
				
			if get_node("Player").playerLevel == 2:
				toggle_gate_state(false, [Vector2i(12, 4), Vector2i(13, 4)] as Array[Vector2i], true)
				toggle_gate_state(false, [Vector2i(12, -7), Vector2i(13, -7)] as Array[Vector2i], true)
				toggle_gate_state(false, [Vector2i(17, -1), Vector2i(17, -2)] as Array[Vector2i], false)
				toggle_gate_state(false, [Vector2i(6, -1), Vector2i(6, -2)] as Array[Vector2i], false)
				
			changeUSBtile(Vector2(6, 11))
			$USBin.play()
			await get_tree().create_timer(randi_range(4, 6)).timeout
			for i in range(10):
				var baseRoom = Room.new(Vector2i(7,-6), Vector2i(12,12), 1)
				spawnEnemiesInRoom(baseRoom)
				await get_tree().create_timer(randi_range(5,10)).timeout
			


	
func spawnEnemiesInRoom(room: Room):
	var numberRoomEnemies = randi_range(1,12)
	for i in range(numberRoomEnemies):
		var randomLocation = Vector2i(randi_range(room.p.x, room.p.x + room.s.x), randi_range(room.p.y, room.p.y + room.s.y))
		if ($Region1Tiles/Tiles.get_cell_source_id(randomLocation) > 1):
			spawnEnemy(randomLocation)
			
func spawnEnemy(ranLoc: Vector2i) -> void:
		var newEnemy = enemyTSCN.instantiate()
		var pixelPos = $Region1Tiles/Tiles.map_to_local(ranLoc)
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(2, 2)
		sprite.texture = enemySpawnSprite
		add_child(sprite)
		sprite.position = pixelPos
		spriteFading(sprite)
		await get_tree().create_timer(3).timeout
		newEnemy.position = pixelPos
		add_child.call_deferred(newEnemy)
		sprite.queue_free()

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
	
func spriteFading(sprite: Sprite2D) -> void:
	var tween = get_tree().create_tween()
	
	tween.set_loops()
	
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
