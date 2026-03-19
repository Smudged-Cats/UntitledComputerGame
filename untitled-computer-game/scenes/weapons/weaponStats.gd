extends Node
class_name WeaponStats

var stats: Dictionary = {
	
	"fireRate": 0.0,
	"projectileCount": 0,
	"spread":0,
	"ammo": 0
}
var projectileStats: ProjectileStats

func _init(fireRate: float, spread:float, projectileStats:ProjectileStats, projectileCount: int = 1, ammo: int = randi_range(5,16)):
	stats["fireRate"] = fireRate
	stats["projectileCount"] = projectileCount
	stats["spread"] = spread
	#print(stats["fireRate"])
	stats["ammo"] = ammo
	self.projectileStats = projectileStats
