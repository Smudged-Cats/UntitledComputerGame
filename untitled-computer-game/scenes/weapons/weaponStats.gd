extends Node
class_name WeaponStats

var stats: Dictionary = {
	"fireRate": 0.0,
	"projectileCount": 0,
	"spread":0
}
var projectileStats: ProjectileStats

func _init(fireRate: float, spread:float, projectileStats:ProjectileStats, projectileCount: int = 1):
	stats["fireRate"] = fireRate
	stats["projectileCount"] = projectileCount
	stats["spread"] = spread
	#print(stats["fireRateaw"])
	self.projectileStats = projectileStats
