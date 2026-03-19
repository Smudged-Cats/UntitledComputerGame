extends Node
class_name MeleeStats

var stats: Dictionary = {
	
	"damage": 0.0,
	"attackCooldown": 0
}


func _init( damage:float, attackCooldown: float):
	stats["damage"] = damage
	stats["attackCooldown"] = attackCooldown
