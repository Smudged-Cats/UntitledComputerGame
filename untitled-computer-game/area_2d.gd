extends Area2D

var weaponBoost:WeaponStats

func applyBoost(entity:Node2D):
	if (entity is Player):
		var pWeaponMuls: WeaponStats = entity._weapon.weaponMuls
		pWeaponMuls.fireRate += weaponBoost.fire
		pWeaponMuls.projectileStats.damage += 
