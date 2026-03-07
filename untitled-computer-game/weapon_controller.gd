extends Node

#Add the projectile class and all its effects
class_name WeaponController

var holder: String
var baseWeapon: Weapon
var baseProjectile = preload("res://scenes/weapons/Projectile.tscn")

#I'm not sure if it makes more sense that have the defaultFireRate be 
# of type float, or of type Cooldown2
func _init(holder:String = "", b:Weapon = Weapon.new(1,1,1)):
	self.holder = holder
	baseWeapon = b
	
	#For some reason, the Cooldown needs to be added as a child
	# node so that it can work properly, even though its added as a node
	# to its class node (*see Cooldown scene)
	add_child(self.baseWeapon.fireRate)

func shoot(dir:Vector2, pos: Vector2) -> void:
	print(baseWeapon.fireRate.timeLeft())
	if (baseWeapon.fireRate.timeLeft() == 0):
		
		var tempP = baseProjectile.instantiate()
		tempP.setProjectile(
			holder,
			baseWeapon.damage,
			baseWeapon.projectileSpeed, 
			dir, 
			pos)
		add_child(tempP)
		
		baseWeapon.fireRate.startTimer()

func setWeapon(w:Weapon):
	baseWeapon = w
	
	#I don't know if adding a child for the new fireRate will add a
	# new child node, or replace the old one
	add_child(self.baseWeapon.fireRate)
