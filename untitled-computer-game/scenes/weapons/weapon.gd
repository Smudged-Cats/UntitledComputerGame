extends Node
class_name Weapon


var fireRate: Cooldown
var damage: float
var projectileSpeed: float
#var projectile: Projectile

func _init(fireRate: float, damage: float, projectileSpeed: float):
	self.fireRate = Cooldown.new(fireRate)
	self.damage = damage
	self.projectileSpeed = projectileSpeed
