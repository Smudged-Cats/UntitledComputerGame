extends Node

#Add the projectile class and all its effects
class_name WeaponController

var baseWeapon: Weapon
var baseFireRate: Cooldown
var baseTestText: String

#I'm not sure if it makes more sense that have the defaultFireRate be 
# of type float, or of type Cooldown2
func _init(defaultFireRate:float, testText:String):
	baseFireRate = Cooldown.new(defaultFireRate)
	add_child(baseFireRate)
	
	baseTestText = testText

func shoot() -> void:
	print(baseFireRate.timeLeft())
	if (baseFireRate.timeLeft() == 0):
		baseFireRate.startTimer()

func setWeapon(w:Weapon):
	baseFireRate.setWaitTime(w.fireRate.getWaitTime())
	baseTestText = w.testText
