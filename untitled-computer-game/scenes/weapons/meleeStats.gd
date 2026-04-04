extends Node
class_name MeleeStats

var stats: Dictionary = {
	
	"damage": 0.0,
	"attackCooldown": 0,
	"3DModel": 0,
	"Sprite": null
}

# 3D Model will be an int corresponding to the model / type of melee weapon.
# - (-1) = N/A for Muls
# - 0 = RGB Sword
# - 1 = Fire Sword
# - 2 = Electric Sythe
# - 3 = Circuit Board Hammer


func _init( damage:float, attackCooldown: float, Model:int):
	stats["damage"] = damage
	stats["attackCooldown"] = attackCooldown
	stats["3DModel"] = Model

#Get the sprite
func getSprite() -> CompressedTexture2D:
	return stats["Sprite"]

func getMeleeText() -> String:
	var meleeText: String = ""
	for key in stats.keys():
		if (key != "3DModel" && key != "Sprite"):
			if(key == "attackCooldown"):
				meleeText += "%s: %.2fs\n" %[key, stats[key]]
			else:
				meleeText += "%s: %d\n" %[key, int(stats[key])]
	return meleeText
