class_name Room

var isRoom = false

var p: Vector2i # Position is located at the top-left of the room
var s: Vector2i

func _init(p: Vector2i, s: Vector2i, isRoom: bool):
	self.p = p
	self.s = s
	self.isRoom = isRoom
