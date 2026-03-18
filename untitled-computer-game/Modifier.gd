class_name Modifier

var weaponBoost: Dictionary
var projectileBoost: Dictionary
var weaponKeyList: Array
var projectileKeyList: Array

func _init(weaponBoost:Dictionary,projectileBoost:Dictionary):
	self.weaponBoost = weaponBoost
	self.projectileBoost = projectileBoost
	weaponKeyList = self.weaponBoost.keys()
	projectileKeyList = self.projectileBoost.keys()

func applyBoost(entity:Node2D):
	if (entity is Player):
		for key in weaponKeyList:
			entity._weapon.weaponMuls.stats[key] += weaponBoost[key]
			
		for key in projectileKeyList:
			entity._weapon.weaponMuls.projectileStats.stats[key] += projectileBoost[key]
		 
func removeBoost(entity:Node2D):
	if (entity is Player):
		for key in weaponKeyList:
			entity._weapon.weaponMuls.stats[key] -= weaponBoost[key]
			
		for key in projectileKeyList:
			entity._weapon.weaponMuls.projectileStats.stats[key] -= projectileBoost[key]
