extends Area2D

var stats: ProjectileStats
var dir: Vector2

#The source variable is meant to prevent friendly fire
# incidents by comparing the characterName of the entity it hits to the
# source, which will also be the characterName string of who shot the weapon
var source: String

func setProjectile(source:String, stats:ProjectileStats, dir:Vector2, pos:Vector2):
	self.source = source
	
	#Creating a deep copy of the projectile stats so that the piercing
	# health works for the projectiles
	self.stats = ProjectileStats.new(
		stats.damage,
		stats.speed,
		stats.shotHealth
	)
	self.dir = dir.normalized()
	position = pos

#There seems to be an issue where the distances of the 
# projectiles sort of "stretch" and "compress depending on where the player is
# moving relative to the projectile
func _physics_process(delta: float) -> void:
	position += dir * stats.speed * delta
	

func _on_body_entered(body: Node2D) -> void:
	#Prevent friendly fire
	if(body is Character):
		if (body.characterName != source):
			body.health -= stats.damage
			
			#Trying to simulate piercing shots by giving the shots
			# health
			stats.shotHealth -= 1
			if (stats.shotHealth <= 0):
				queue_free()
			else:
				position += 5*dir
		else:
			position += 5*dir
	
	#Despawn if hitting a wall
	if (body is StaticBody2D):
		queue_free()
