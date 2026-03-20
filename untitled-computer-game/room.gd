class_name Room

var p: Vector2i # Position is located at the top-left of the room
var s: Vector2i

func _init(p: Vector2i, s: Vector2i):
	self.p = p
	self.s = s
