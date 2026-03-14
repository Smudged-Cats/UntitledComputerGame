extends Area2D
class_name RadialHitbox

var attacker: Character
var damage: int
var duration: float = 0.25

var entitiesAffected: Array[Character]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(duration).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		#if body != attacker:
		
		# To prevent enemies from hitting their own kind
		if body.characterName != attacker.characterName:
			body.get_parent().registerHit()
			body.takeDamage(damage, self.attacker.global_position, attacker._dashWindup)
			print("50 Damage Delivered")
			

func set_attacker(char: Character) -> void:
	self.attacker = char
	
func set_damage(damage: int) -> void:
	self.damage = damage
