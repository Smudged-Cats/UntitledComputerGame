extends Node2D

@onready var gates: TileMapLayer = $Region1Tiles/GateTiles

var gatesAlongX = []
var gatesAlongY = []

# hard-coded positions for the pre-placed gates in testMap
func _ready() -> void:
	var gates1 = [Vector2i(1, 5), Vector2i(2, 5)]
	var gates2 = [Vector2i(-3, 9), Vector2i(-3, 8)]
	gatesAlongX.append(gates1)
	gatesAlongY.append(gates2)


func toggle_gate_state(is_active:bool) -> void:
	print("Woah woah waoh")
	
	# Atlas texture position for open and closed gates
	var openGates = 7
	var closedGates = 6
	
	# Get the gate textures from the texture positions
	var sheet_for_1 = openGates if is_active else closedGates
	var sheet_for_2 = closedGates if is_active else openGates
	
	for gate in gatesAlongX:
		var i = 0
		for pos in gate:
			gates.set_cell(pos, sheet_for_1, Vector2i(i, 0))
			i += 1
	
	for gate in gatesAlongY:
		var j = 2
		for pos in gate:
			gates.set_cell(pos, sheet_for_2, Vector2i(j, 0))
			j += 1
