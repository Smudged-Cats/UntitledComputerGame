extends Node
class_name ProjectileStats

var stats: Dictionary = {
	"damage": 0.0,
	"speed": 0.0,
	"shotHealth": 0,
	"knockback": 0
}
var projectileSpriteNum: int:
	set(value):
		if (value < 0):
			projectileSpriteNum = 0
		else:
			projectileSpriteNum = value
	get():
		return projectileSpriteNum

func _init(damage:float, speed:float, shotHealth: int = 1, knockback:float = 0, projectileSpriteNum:int = 0):
	stats["damage"] = damage
	stats["speed"] = speed
	stats["shotHealth"] = shotHealth
	stats["knockback"] = knockback
	self.projectileSpriteNum = projectileSpriteNum
