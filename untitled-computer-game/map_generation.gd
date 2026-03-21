extends Node2D

@onready var floor_layer = $Tiles

var tile_set = preload("res://resources/floor_tile_set.tres")

var socket_tiles_atlas_id = 0
var socket_tile_top_left = Vector2i(0, 0)
var socket_tile_top_right = Vector2i(1, 0)
var socket_tile_bottom_left = Vector2i(0, 1)
var socket_tile_bottom_right = Vector2i(1, 1)

var room_tile_v2i = Vector2i(0, 0)
var room_corner_tile_v2i = Vector2i(1, 0)
var tunnel_tile_v2i = Vector2i(1, 0)

# Stores possible positions for patterns to generate at
var patternSockets = []

# Stores all generated pattern objects
var patternsGenerated = []

func _ready():
	generate_patterns(20)
	#generate_pattern(0)
	
	#for socket in patternSockets:
		#print(socket.p)
	#
	#var socketToPop = patternSockets.pop_at(0)
	#generate_pattern(0, socketToPop)
	#
	#for socket in patternSockets:
		#print(socket.p)
	#
	#socketToPop = patternSockets.pop_at(0)
	#generate_pattern(0, socketToPop)
	#
	#for socket in patternSockets:
		#print(socket.p)

func generate_patterns(n: int) -> void:
	
	if n <= 0: return
	
	# Generate the root room
	generate_pattern(0)
	
	for i in (n - 1):
		
		var success = false
		while success == false:
			var randomSocketIndex = randi_range(0, patternSockets.size() - 1)
			var randomPatternIndex = randi_range(0, 6)
			
			success = generate_pattern(randomPatternIndex, randomSocketIndex)
		

func generate_pattern(id: int = -1, layerTileSocketIndex: int = -1) -> bool:
	#print("Generating pattern...")
	
	
	var pattern: TileMapPattern = pick_pattern(id)
	
	# Get all the sockets from the pattern
	var patternSocketsToAdd = get_sockets_from_pattern(pattern)
	
	# If we don't want to connect this pattern to a socket, then just generate at 0,0
	if layerTileSocketIndex == -1:
		#print("Placing at: 0,0")
		place_pattern(pattern, Vector2i.ZERO)
		patternSockets.append_array(patternSocketsToAdd)
		return true
	
	var layerTileSocket = patternSockets[layerTileSocketIndex]
	
	var socketTypeToMatch = get_inverse_pattern_socket_type(layerTileSocket.type) 
	#print("Type to match:" + str(socketTypeToMatch))
	
	# Check every socket in the pattern to see if the pattern fits
	for i in (patternSocketsToAdd.size()):
		var patternSocket = patternSocketsToAdd[i]
		#print("Socket type: " + str(patternSocket.type))
		if patternSocket.type != socketTypeToMatch: continue
		
		#print("Found matching socket in pattern")
		
		
		# Get the position that the pattern would be in for this socket to fit
		var patternP = layerTileSocket.p - patternSocket.p
		
		# Check for collisions
		var collision_detected = check_pattern_placement_for_collision(pattern, patternP)
		if collision_detected:
			#print("COLLISION!")
			continue
			
		# If we get here, then we should be good to place the pattern down.
		
		# Remove the current socket from the list of available sockets
		patternSocketsToAdd.pop_at(i)
		
		#print("Placing at: " + str(patternP))
		place_pattern(pattern, patternP)
		for j in (patternSocketsToAdd.size()):
			patternSocketsToAdd[j].p += patternP
		
		patternSockets.append_array(patternSocketsToAdd)
		return true
	
	#print("Failed to generate room!")
	return false
	
# Get all the sockets in the pattern
func get_sockets_from_pattern(pattern: TileMapPattern):
	
	var s = pattern.get_size()
	var patternSocketsToAdd = []
	
	# O(n^2) to check all tiles in the pattern, sorry
	# TODO: 	We could actually detect socket tiles in an offline process and cache them, it could be
	#			faster but would require a bit of work to code.
	for x in s.x:
		for y in s.y:
			var patternTileIsSocket = pattern.get_cell_source_id(Vector2i(x, y)) == socket_tiles_atlas_id
			#var layerTileIsSocket = floor_layer.get_cell_source_id(Vector2i(p.x + x, p.y + y)) == socket_tiles_atlas_id
			
			if patternTileIsSocket:
				var newPatternSocket = PatternSocket.new()
				newPatternSocket.p = Vector2i(x, y)
				newPatternSocket.type = pattern.get_cell_atlas_coords(Vector2i(x, y))
				patternSocketsToAdd.append(newPatternSocket)
	return patternSocketsToAdd
	
# Check if placing a pattern at point p would cause a collision
func check_pattern_placement_for_collision(pattern: TileMapPattern, p: Vector2i) -> bool:
	
	var s = pattern.get_size()
	for x in s.x:
		for y in s.y:
			var patternTileId = pattern.get_cell_source_id(Vector2i(x, y))
			var layerTileId = floor_layer.get_cell_source_id(Vector2i(p.x + x, p.y + y))
			
			if (patternTileId != -1 and patternTileId != socket_tiles_atlas_id) and (layerTileId != -1 and layerTileId != socket_tiles_atlas_id):
				return true
	return false

func get_inverse_pattern_socket_type(type: Vector2i) -> Vector2i:
	if type == socket_tile_top_left: return socket_tile_bottom_right
	if type == socket_tile_top_right: return socket_tile_bottom_left
	if type == socket_tile_bottom_left: return socket_tile_top_right
	return socket_tile_top_left

# Force place a pattern at point p
func place_pattern(pattern: TileMapPattern, p: Vector2i):
	floor_layer.set_pattern(p, pattern)
	var newRoom = Room.new(p, pattern.get_size())
	patternsGenerated.append(newRoom)


# Return a pattern via index. If no index, return a random pattern
func pick_pattern(id: int = -1) -> TileMapPattern:
	if id < 0 or id >= tile_set.get_patterns_count(): 
		id = randi_range(0, tile_set.get_patterns_count() - 1)
	return tile_set.get_pattern(id)


func _on_timer_timeout() -> void:
	var success = false
	while success == false:
		var randomSocketIndex = randi_range(0, patternSockets.size() - 1)
		var randomPatternIndex = randi_range(0, 6)
		
		success = generate_pattern(randomPatternIndex, randomSocketIndex)
