extends Node

#Add the projectile class and all its effects
class_name WeaponController

var holder: String
var fireRateTimer: Cooldown
var baseWeapon: Weapon

#While the weaponMods is of type weapon, it is supposed be treated  as a bunch of
# "multipliers" that relate to the respective stats in the weapon class
var weaponMuls: Weapon
var baseProjectile = preload("res://scenes/weapons/Projectile.tscn")

#I'm not sure if it makes more sense that have the defaultFireRate be 
# of type float, or of type Cooldown2
func _init(holder:String = "", b:Weapon = Weapon.new(1,ProjectileStats.new(1,1))):
	self.holder = holder
	baseWeapon = b
	weaponMuls = Weapon.new(1,ProjectileStats.new(1,1,1))
	fireRateTimer = Cooldown.new(1.0)
	
	#For some reason, the Cooldown needs to be added as a child
	# node so that it can work properly, even though its added as a node
	# to its class node (*see Cooldown scene)
	add_child(fireRateTimer)

func shoot(dir:Vector2, pos: Vector2) -> void:
	#print(baseWeapon.fireRate.timeLeft())
	if (fireRateTimer.timeLeft() == 0):
		
		var tempP = baseProjectile.instantiate()
		tempP.setProjectile(
			holder,
			baseWeapon.projectileStats, 
			dir, 
			pos)
		#print(baseWeapon.projectileStats.shotHealth)
		add_child(tempP)
		
		fireRateTimer.startTimer(baseWeapon.fireRate)

func setWeapon(w:Weapon):
	baseWeapon = w
