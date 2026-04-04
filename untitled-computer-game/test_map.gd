extends Node2D

@onready var enemySpawner = preload("res://scenes/enemySpawner.tscn")
@onready var enemyTSCN = preload("res://scenes/controllers/enemy.tscn")
@onready var droppedItem = preload("res://scenes/weapons/droppedItem.tscn")
@onready var startMenu = preload("res://start_menu.tscn")
@onready var tilemap_instance = get_node_or_null("TileMapScene")

@onready var onObjective = false

@onready var enemySpawnSprite = preload("res://art/AntiBugSymbol.png")

@onready var tutorialMusic = preload("res://art/Music/doxycyclin-sci-fi-retro-style-music-172779.mp3")

@onready var timeLeft = $ObjectivePoint/Timer.time_left




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TutorialMusic.play()
	get_node("Player").get_node("Camera2D").get_node("HUD").get_node("PlayerStatus").get_node("SurvivePrompt").visible = false
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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
			get_node("Player").get_node("Camera2D").get_node("HUD").get_node("PlayerStatus").get_node("SurvivePrompt").visible = false
			get_node("Player").playerLevel += 1
			var menuScene = load("res://start_menu.tscn")
			var newMenuScene = menuScene.instantiate()
			newMenuScene._init(true)
			get_tree().root.add_child(newMenuScene)
			var tutorial = get_node_or_null("Player/Tutorial2")
			if tutorial:
				get_node("Player").get_node("Tutorial2").queue_free()
			get_node("Player").reparent(newMenuScene)
			queue_free()

	if onObjective and Input.is_action_just_pressed("interact"):
		if get_node("Player").activateBombItem():
			tilemap_instance.changeUSBtile(Vector2(-4, 13))
			tilemap_instance.toggle_gate_state(false, [Vector2i(-3, 9), Vector2i(-3, 8)] as Array[Vector2i], false)
			tilemap_instance.toggle_gate_state(true, [Vector2i(1, 5), Vector2i(2, 5)] as Array[Vector2i], true)
			$USBin.play()

		
			for i in range(5):
				var tutorialRoom = Room.new(Vector2i(-4,4), Vector2i(8,8), 1)
				spawnEnemiesInRoom(tutorialRoom)
				await get_tree().create_timer(10).timeout

		
		
func _on_objective_point_body_entered(body: Node2D) -> void:
	onObjective = true
func _on_objective_point_body_exited(body: Node2D) -> void:
	onObjective = false
	
func spawnEnemiesInRoom(room: Room):
	var numberRoomEnemies = 5
	for i in range(numberRoomEnemies):
		var randomLocation = Vector2i(randi_range(room.p.x, room.p.x + room.s.x), randi_range(room.p.y, room.p.y + room.s.y))
		if ($TileMapScene/Region1Tiles/Tiles.get_cell_source_id(randomLocation) != -1):
			spawnEnemy(randomLocation)
			
func spawnEnemy(ranLoc: Vector2i) -> void:
		var newEnemy = enemyTSCN.instantiate()
		var pixelPos = $TileMapScene/Region1Tiles/Tiles.map_to_local(ranLoc)
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
		if ($TileMapScene/Region1Tiles/Tiles.get_cell_source_id(randomLocation) != -1):
			var newDroppedItem = droppedItem.instantiate()
			newDroppedItem.setWeaponType(weaponTypes[randi_range(0,2)])
			var pixelPos = $TileMapScene/Region1Tiles/Tiles.map_to_local(randomLocation)
			newDroppedItem.position = pixelPos
			add_child(newDroppedItem)
			
func spriteFading(sprite: Sprite2D) -> void:
	var tween = get_tree().create_tween()
	
	tween.set_loops()
	
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
	
	
