class_name Modifier

var weaponBoost: Dictionary
var projectileBoost: Dictionary
var meleeBoost: Dictionary
var weaponKeyList: Array
var projectileKeyList: Array
var meleeBoostKeys: Array

func _init(weaponBoost:Dictionary,projectileBoost:Dictionary,meleeBoost:Dictionary):
	self.weaponBoost = weaponBoost
	self.projectileBoost = projectileBoost
	self.meleeBoost = meleeBoost
	weaponKeyList = self.weaponBoost.keys()
	projectileKeyList = self.projectileBoost.keys()
	meleeBoostKeys = self.meleeBoost.keys()

func applyBoost(entity:Node2D):
	if (entity is Player):
		for key in weaponKeyList:
			entity._weapon.weaponMuls.stats[key] += weaponBoost[key]
			
		for key in projectileKeyList:
			entity._weapon.weaponMuls.projectileStats.stats[key] += projectileBoost[key]
			
		for key in meleeBoostKeys:
			entity._character.melee.meleeMuls.stats[key] += meleeBoost[key]

func removeBoost(entity:Node2D):
	if (entity is Player):
		for key in weaponKeyList:
			entity._weapon.weaponMuls.stats[key] -= weaponBoost[key]
			
		for key in projectileKeyList:
			entity._weapon.weaponMuls.projectileStats.stats[key] -= projectileBoost[key]
			
		for key in meleeBoostKeys:
			entity._character.melee.meleeMuls.stats[key] -= meleeBoost[key]
