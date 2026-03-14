extends Node2D
class_name Weapon


var fireRate: float
var projectileStats: ProjectileStats
#var projectile: Projectile

func _init(fireRate: float, projectileStats:ProjectileStats):
	self.fireRate = fireRate
	self.projectileStats = projectileStats
