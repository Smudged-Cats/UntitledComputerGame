extends Area2D

var attacker: Character
var entitiesAffected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		#if body != attacker:
		
		# To prevent enemies from hitting their own kind
		if body.characterName != attacker.characterName:
			body.health = 0
			attacker.health -= 1
			

func set_attacker(char: Character) -> void:
	self.attacker = char
