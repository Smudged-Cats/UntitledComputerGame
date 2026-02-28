extends CharacterBody2D
class_name Character

#var team: int = 0
static var newCharacterId = 0
var characterId = 0

@export
var characterName = "Unnamed Character"

@export
var health = 100

@export
var speed: float = 150.0
var acceleration: float = 25.0
var deceleration: float = 25.0

var move_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	characterId = newCharacterId
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("Camera3D").global_position.x += characterId * 10
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").global_position.x += characterId * 10
	newCharacterId += 1

func _physics_process(delta: float) -> void:
	var velocity: Vector2 = self.velocity
	var direction: Vector2 = move_dir

	if direction != Vector2.ZERO:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		velocity.y = move_toward(velocity.y, direction.y * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration)
		velocity.y = move_toward(velocity.y, 0.0, deceleration)

	self.velocity = velocity
	move_and_slide()

func look_in_direction(dir: Vector2) -> void:
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").rotation.y = -global_position.direction_to(dir + self.global_position).angle()

func set_move_dir(dir: Vector2) -> void:
	self.move_dir = dir

func get_health() -> int:
	return self.health
