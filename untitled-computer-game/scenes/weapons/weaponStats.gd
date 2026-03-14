extends Node
class_name WeaponStats


var fireRate: float
var projectileStats: ProjectileStats
#var projectile: Projectile

func _init(fireRate: float, projectileStats:ProjectileStats):
	self.fireRate = fireRate
	self.projectileStats = projectileStats
