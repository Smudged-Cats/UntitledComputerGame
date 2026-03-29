extends Node
class_name MeleeStats

var stats: Dictionary = {
	
	"damage": 0.0,
	"attackCooldown": 0,
	"3DModel": 0
}

# 3D Model will be an int corresponding to the model / type of melee weapon.
# - (-1) = N/A for Muls
# - 0 = RGB Sword
# - 1 = Fire Sword
# - 2 = Electric Sythe
# - 3 = Circuit Board Hammer


func _init( damage:float, attackCooldown: float, Model:int):
	stats["damage"] = damage
	stats["attackCooldown"] = attackCooldown
	stats["3DModel"] = Model
