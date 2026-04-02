class_name Modifier

var weaponBoost: Dictionary
var projectileBoost: Dictionary
var meleeBoost: Dictionary

func _init(weaponBoost:Dictionary,projectileBoost:Dictionary,meleeBoost:Dictionary):
	self.weaponBoost = weaponBoost
	
	#Remvoe visual components
	self.weaponBoost.erase("3DModel")
	self.weaponBoost.erase("Sprite")
	
	self.projectileBoost = projectileBoost
	
	self.meleeBoost = meleeBoost
	self.meleeBoost.erase("3DModel")
	self.meleeBoost.erase("Sprite")

func applyBoost(entity:Node2D):
	if (entity is Player):
		for key in weaponBoost.keys():
			entity._weapon.weaponMuls.stats[key] += weaponBoost[key]
			
		for key in projectileBoost.keys():
			entity._weapon.weaponMuls.projectileStats.stats[key] += projectileBoost[key]
			
		for key in meleeBoost.keys():
			entity._character.melee.meleeMuls.stats[key] += meleeBoost[key]

func removeBoost(entity:Node2D):
	if (entity is Player):
		for key in weaponBoost.keys():
			entity._weapon.weaponMuls.stats[key] -= weaponBoost[key]
			
		for key in projectileBoost.keys():
			entity._weapon.weaponMuls.projectileStats.stats[key] -= projectileBoost[key]
			
		for key in meleeBoost.keys():
			entity._character.melee.meleeMuls.stats[key] -= meleeBoost[key]

func getBoosts() -> String:
	var text: String = ""
	for k in weaponBoost.keys():
		#Don't display stats that have no boosts
		if (weaponBoost[k] != 0):
			text += "%.1fx extra %s (Ranged)\n" % [weaponBoost[k],k]
	
	for k in projectileBoost.keys():
		if (projectileBoost[k] != 0):
			text += "%.1fx extra %s (Ranged)\n" % [projectileBoost[k],k]
	
	for k in meleeBoost.keys():
		if (meleeBoost[k] != 0):
			text += "%.1fx extra %s (Melee)\n" % [meleeBoost[k],k]
		
	return text
