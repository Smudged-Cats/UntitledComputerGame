extends Area2D

var stats: ProjectileStats
var dir: Vector2

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
		stats.stats["shotHealth"] * statMuls.stats["shotHealth"]
	)
	dir = d.normalized()
	position = pos

#There seems to be an issue where the distances of the 
# projectiles sort of "stretch" and "compress depending on where the player is
# moving relative to the projectile
func _physics_process(delta: float) -> void:
	position += dir * stats.stats["speed"] * delta
	#print(dir)
	

func _on_body_entered(body: Node2D) -> void:
	#Prevent friendly fire
	if(body is Character):
		if (body.characterName != source):
			body.takeDamage(stats.stats["damage"], body.global_position + self.global_position, 0)
			
			#Trying to simulate piercing shots by giving the shots
			# health
			stats.stats["shotHealth"] -= 1
			if (stats.stats["shotHealth"] <= 0):
				queue_free()
			else:
				position += 5*dir
		else:
			position += 5*dir
	
	#Despawn if hitting a wall
	if (body is StaticBody2D):
		#richocet(body)
		queue_free()

# Function for richochet, which can be worked on later
func richocet(body: Node2D):
	if (body is StaticBody2D):
		var p: Area2D = Area2D.new()
		body.move_and_collide()
		'''
		#var newAngle: float = 2*dir.angle() + PI
		#dir = Vector2(cos(newAngle),sin(newAngle))
		#var getWallAngle:float = body.get_angle_to(self.global_position) + PI
		#var getWallAngle:float = self.get_angle_to(body.position)
		#print(getWallAngle, ", ", dir.angle())
		#var n: Vector2 = Vector2(cos(getWallAngle),sin(getWallAngle))
		var n: Vector2 = Vector2(cos(PI/4),sin(PI/4))
		var dotProd = dir.x*n.x + dir.y*n.y
		print("E")
		dir = dir - 2*dotProd*n
		
		#dir.y = -sin(dir.angle())
		'''
