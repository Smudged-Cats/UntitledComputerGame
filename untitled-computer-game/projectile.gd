extends Area2D

var killTimer: float
var stats: ProjectileStats
var dir: Vector2
@onready var removeProjectile = false

#The source variable is meant to prevent friendly fire
# incidents by comparing the characterName of the entity it hits to the
# source, which will also be the characterName string of who shot the weapon
var source: String

#Add weaponMuls.projectileStats as a parameter
func setProjectile(source:String, stats:ProjectileStats, statMuls:ProjectileStats, d:Vector2, pos:Vector2):
	self.source = source
	
	#Creating a deep copy of the projectile stats so that the piercing
	# health works for the projectiles
	self.stats = ProjectileStats.new(
		stats.stats["damage"] * statMuls.stats["damage"],
		stats.stats["speed"] * statMuls.stats["speed"],
		stats.stats["shotHealth"] * statMuls.stats["shotHealth"],
		stats.stats["knockback"] * statMuls.stats["knockback"] - 650
	)
	killTimer = 5.0
	if (self.stats.stats["speed"] > 2000):
		self.stats.stats["speed"] = 2000
	dir = d.normalized()
	position = pos

#There seems to be an issue where the distances of the 
# projectiles sort of "stretch" and "compress depending on where the player is
# moving relative to the projectile
func _physics_process(delta: float) -> void:
	position += dir * stats.stats["speed"] * delta
	#print(dir)

func _on_body_entered(body: Node2D) -> void:
	if (removeProjectile): return
	#Prevent friendly fire
	if(body is Character):
		if (body.characterName != source and body.health > 0):
			body.takeDamage(stats.stats["damage"], self.global_position, stats.stats["knockback"])
			
			#Trying to simulate piercing shots by giving the shots
			# health
			stats.stats["shotHealth"] -= 1
			if (stats.stats["shotHealth"] <= 0):
				#queue_free()
				tryToRemoveProjectile()
				#queue_free.call_deferred()
			else:
				position += 5*dir
		else:
			position += 5*dir
	
	#Despawn if hitting a wall
	if (body is TileMapLayer):
		#richocet(body)
		#queue_free()
		tryToRemoveProjectile()
		#queue_free.call_deferred()

func tryToRemoveProjectile():
	removeProjectile = true
	call_deferred("queue_free")
