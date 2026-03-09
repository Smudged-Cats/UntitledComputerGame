extends Area2D

var stats: ProjectileStats
var dir: Vector2

#The source variable is meant to prevent friendly fire
# incidents by comparing the characterName of the entity it hits to the
# source, which will also be the characterName string of who shot the weapon
var source: String

func setProjectile(source:String, stats:ProjectileStats, d:Vector2, pos:Vector2):
	self.source = source
	
	#Creating a deep copy of the projectile stats so that the piercing
	# health works for the projectiles
	self.stats = ProjectileStats.new(
		stats.damage,
		stats.speed,
		stats.shotHealth
	)
	dir = d.normalized()
	position = pos

#There seems to be an issue where the distances of the 
# projectiles sort of "stretch" and "compress depending on where the player is
# moving relative to the projectile
func _physics_process(delta: float) -> void:
	position += dir * stats.speed * delta
	#print(dir)
	

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
		
		#var getWallAngle:float = body.get_angle_to(self.global_position) + PI
		var getWallAngle:float = self.get_angle_to(body.position)
		print(getWallAngle, ", ", dir.angle())
		var n: Vector2 = Vector2(cos(getWallAngle),sin(getWallAngle))
		var dotProd = dir.x*n.x + dir.y*n.y
		
		dir = dir - 2*dotProd*n
		
		#dir.y = -sin(dir.angle())
		#queue_free()
