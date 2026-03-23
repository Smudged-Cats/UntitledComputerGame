extends Node2D

@onready var gates: TileMapLayer = $Region1Tiles/GateTiles
@onready var tiletops: TileMapLayer = $Region1Tiles/TileTop



func _ready() -> void:
	$Region1Tiles/BarrierTiles.visible = false


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
	var usbSource = 3
	tiletops.set_cell(pos, usbSource, Vector2i(1, 0))
