extends Node
class_name MeleeController

var attacker:Character
var meleeSwingScene = preload("res://scenes/radialHitbox.tscn")
var baseMelee: MeleeStats
var meleeMuls: MeleeStats
var attackCooldown: Cooldown

func _init(attacker:Character, baseMelee:MeleeStats = null):
	self.attacker = attacker
	self.baseMelee = baseMelee
	meleeMuls = MeleeStats.new(1.0,1.0,-1)
	attackCooldown = Cooldown.new(1.0)
	add_child(attackCooldown)

func attack() -> void:
	if attackCooldown.timeLeft() == 0:
		var newHitbox = meleeSwingScene.instantiate()
		newHitbox.set_attacker(attacker)
		print(attacker.characterName)
		newHitbox.set_damage(baseMelee.stats["damage"]*meleeMuls.stats["damage"])
		attacker.add_child(newHitbox)
		#add_child(newHitbox)
		
		var totalTime:float = baseMelee.stats["attackCooldown"]/meleeMuls.stats["attackCooldown"]
		attackCooldown.startTimer(totalTime)

func getDamage() -> float:
	return baseMelee.stats["damage"] * meleeMuls.stats["damage"]

func getMeleeBoosts() -> String:
	var text: String = ""
	for k in meleeMuls.stats.keys():
		var currBoost = meleeMuls.stats[k]
		if (k != "Sprite" && k != "3DModel"):
			if (currBoost != 1):
				text += "%.1fx %s\n" % [meleeMuls.stats[k] - 1,k]
	return text
