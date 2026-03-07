extends Node
class_name ProjectileStats

var damage: float
var speed: float
var shotHealth: int

func _init(damage:float, speed:float, shotHealth: int = 1):
	self.damage = damage
	self.speed = speed
	self.shotHealth = shotHealth
