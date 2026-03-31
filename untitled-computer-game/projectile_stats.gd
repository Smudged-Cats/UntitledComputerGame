extends Node
class_name ProjectileStats

var stats: Dictionary = {
	"damage": 0.0,
	"speed": 0.0,
	"shotHealth": 0,
	"knockback": 0
}

func _init(damage:float, speed:float, shotHealth: int = 1, knockback:float = 0):
	stats["damage"] = damage
	stats["speed"] = speed
	stats["shotHealth"] = shotHealth
	stats["knockback"] = knockback
