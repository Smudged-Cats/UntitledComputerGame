extends Node2D

@onready var floor_layer = $Tiles

var atlas_id = 5
var room_tile_v2i = Vector2i(0, 0)
var room_corner_tile_v2i = Vector2i(1, 0)
var tunnel_tile_v2i = Vector2i(1, 0)

class Room:
	var p: Vector2i # Position is located at the top-left of the room
	var s: Vector2i

# Breadth first approach to generate rooms

const PADDING = 2
const RANDOM_OFFSET = 2

# Stores possible positions for rooms to generate at
var roomsToGenerate = []

# Stores all generated room objects
var roomsGenerated = []

func _ready() -> void:
	
	# Start generation at the 0, 0 coordinate
	roomsToGenerate.append(Vector2i(0, 0))
	
	generate_rooms(20)

# TODO: make this iterative instead of a recursive function
func generate_rooms(roomsLeft) -> void:
	
	if roomsLeft == 0: return
	
	var room_pos: Vector2i
	var room_size = Vector2i(randi_range(3, 8), randi_range(3, 8))
	
	# Attempt to generate room
	var room_success = false
	while room_success == false:
		var numOfRoomPositions = len(roomsToGenerate)
		if numOfRoomPositions == 0: return
		room_pos = roomsToGenerate.pop_at(randi_range(0, numOfRoomPositions - 1))
		room_success = generate_room(room_pos - room_size/2, room_size)
	
	# add the new possible positions to generate a room at
	roomsToGenerate.append(room_pos + Vector2i(0, -room_size.y) + Vector2i.UP * PADDING + Vector2i(randi_range(-RANDOM_OFFSET, RANDOM_OFFSET), -PADDING))
	roomsToGenerate.append(room_pos + Vector2i(0, room_size.y) + Vector2i.DOWN * PADDING + Vector2i(randi_range(-RANDOM_OFFSET, RANDOM_OFFSET), PADDING))
	roomsToGenerate.append(room_pos + Vector2i(-room_size.y, 0) + Vector2i.LEFT * PADDING + Vector2i(-PADDING, randi_range(-RANDOM_OFFSET, RANDOM_OFFSET)))
	roomsToGenerate.append(room_pos + Vector2i(room_size.y, 0) + Vector2i.RIGHT * PADDING + Vector2i(PADDING, randi_range(-RANDOM_OFFSET, RANDOM_OFFSET)))
	
	# Recurse
	generate_rooms(roomsLeft - 1)

# Generate a room given the position and size
func generate_room(p: Vector2i, s: Vector2i = Vector2i(1, 1)) -> bool:
	
	# Check for any room collision + padding
	for x in range(s.x + PADDING*2):
		for y in range(s.y + PADDING*2):
			if floor_layer.get_cell_source_id(Vector2i(p.x + x - PADDING, p.y + y - PADDING)) == atlas_id: return false
	
	# Paint the room
	#for x in range(s.x):
		#for y in range(s.y):
			#floor_layer.set_cell(Vector2i(p.x + x, p.y + y), atlas_id, room_tile_v2i)
	
	var pattern: TileMapPattern = floor_layer.get_pattern( [Vector2i(6, 6)] )
	pattern.set_size(Vector2i(5, 5))
	print(pattern.get_used_cells())
	floor_layer.set_pattern(p, pattern)
	
	# Debug corner tile
	floor_layer.set_cell(Vector2i(p.x, p.y), atlas_id, room_corner_tile_v2i)
	
	var newRoom = Room.new()
	newRoom.p = p
	newRoom.s = s
	roomsGenerated.append(newRoom)
	return true
