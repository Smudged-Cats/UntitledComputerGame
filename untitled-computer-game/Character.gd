extends CharacterBody2D
class_name Character

const SPEED: float = 150.0
const ACCELERATION: float = 25.0
const DECELLERATION: float = 25.0

var move_dir: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	var velocity: Vector2 = self.velocity
	var direction: Vector2 = move_dir

	if direction != Vector2.ZERO:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION)
		velocity.y = move_toward(velocity.y, direction.y * SPEED * 0.5, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0.0, DECELLERATION)
		velocity.y = move_toward(velocity.y, 0.0, DECELLERATION)

	self.velocity = velocity
	move_and_slide()


func set_move_dir(dir: Vector2) -> void:
	move_dir = dir
