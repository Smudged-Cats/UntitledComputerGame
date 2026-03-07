extends Node
class_name Weapon


var fireRate: Cooldown
var projectileStats: ProjectileStats
#var projectile: Projectile

func _init(fireRate: float, projectileStats:ProjectileStats):
	self.fireRate = Cooldown.new(fireRate)
	self.projectileStats = projectileStats
