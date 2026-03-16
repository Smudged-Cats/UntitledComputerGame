extends Node
class_name WeaponStats

var stats: Dictionary = {
	"fireRate": 0.0
}
var projectileStats: ProjectileStats

func _init(fireRate: float, projectileStats:ProjectileStats):
	stats["fireRate"] = fireRate
	#print(stats["fireRateaw"])
	self.projectileStats = projectileStats
