extends Area2D

var damage: float
var speed: float
var dir: Vector2

#The source variable is meant to prevent friendly fire
# incidents by comparing the characterName of the entity it hits to the
# source, which will also be the characterName string of who shot the weapon
var source: String

func setProjectile(source:String, damage:float, speed:float, dir:Vector2, pos:Vector2):
	self.source = source
	self.damage = damage
	self.speed = speed
	self.dir = dir.normalized()
	position = pos

#There seems to be an issue where the distances of the 
# projectiles sort of "stretch" and "compress depending on where the player is
# moving relative to the projectile
func _physics_process(delta: float) -> void:
	position += dir * speed * delta
	

func _on_body_entered(body: Node2D) -> void:
	#Prevent friendly fire
	if(body is Character):
		if (body.characterName != source):
			body.health -= damage
			queue_free()
		else:
			position += 5*dir
	
	#Despawn if hitting a wall
	if (body is StaticBody2D):
		queue_free()
