extends CharacterBody2D
class_name Character

#var team: int = 0

@export
var Health = 100

@export
var Speed: float = 150.0
var Acceleration: float = 25.0
var Decelleration: float = 25.0

var move_dir: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	var velocity: Vector2 = self.velocity
	var direction: Vector2 = move_dir

	if direction != Vector2.ZERO:
		velocity.x = move_toward(velocity.x, direction.x * Speed, Acceleration)
		velocity.y = move_toward(velocity.y, direction.y * Speed, Acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0.0, Decelleration)
		velocity.y = move_toward(velocity.y, 0.0, Decelleration)

	self.velocity = velocity
	move_and_slide()


func set_move_dir(dir: Vector2) -> void:
	self.move_dir = dir

func get_health() -> int:
	return self.Health
