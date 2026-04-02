extends Node
class_name WeaponStats

var stats: Dictionary = {
	
	"fireRate": 0.0,
	"projectileCount": 0,
	"spread":0,
	"ammo": 0,
	"3DModel": 0,
	"Sprite" : null
}

# 3D Model will be an int corresponding to the model / type of melee weapon.
# - 1 = Electric Blaster
# - 0 = Circuit Board Blaster
# - 2 = Red Blaster
# - 3 = Basic Blaster


var projectileStats: ProjectileStats

func _init(fireRate: float, spread:float, projectileStats:ProjectileStats, Model:int, projectileCount: int = 1, ammo: int = randi_range(15,50)):
	stats["fireRate"] = fireRate
	stats["projectileCount"] = projectileCount
	stats["spread"] = spread
	#print(stats["fireRate"])
	stats["ammo"] = float(ammo)
	stats["3DModel"] = Model
	self.projectileStats = projectileStats

#Get the sprite
func getSprite() -> CompressedTexture2D:
	return stats["Sprite"]
