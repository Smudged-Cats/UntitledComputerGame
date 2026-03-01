extends CharacterBody2D
class_name Character

signal health_changed(newHealth: int)

static var newCharacterId = 0
var id = 0

@export var characterName = "Unnamed Character"

@export var health: int = 100:
	set(value):
		if health != value:
			health = value
			# Emit the signal with the new value as an argument
			emit_signal("health_changed", health)

@export var speed: float = 300.0
var acceleration: float = 25.0
var deceleration: float = 25.0

var move_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	
	# Assign the character a new id
	self.id = newCharacterId
	newCharacterId += 1
	
	# Set the position of the 3d model so that it doesn't interfere with other 3d models
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("Camera3D").global_position.x += self.id * 10
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").global_position.x += self.id * 10

func _physics_process(delta: float) -> void:
	var direction: Vector2 = move_dir

	if direction != Vector2.ZERO:
		self.velocity.x = move_toward(self.velocity.x, direction.x * speed, acceleration)
		self.velocity.y = move_toward(self.velocity.y, direction.y * speed, acceleration)
	else:
		self.velocity.x = move_toward(self.velocity.x, 0.0, deceleration)
		self.velocity.y = move_toward(self.velocity.y, 0.0, deceleration)

	move_and_slide()
	
	self.z_index = self.global_position.y

func look_in_direction(dir: Vector2) -> void:
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").rotation.y = -global_position.direction_to(dir + self.global_position).angle()

func set_move_dir(dir: Vector2) -> void:
	self.move_dir = dir

func get_health() -> int:
	return self.health
	
func dashAttack() -> void:
	var mouseDirection: Vector2 = (get_global_mouse_position() - self.global_position).normalized()
	self.velocity.x = mouseDirection.x * 750
	self.velocity.y = mouseDirection.y * 750
	
func takeDamage(sourcePosition: Vector2) -> void:
	var damageDirection: Vector2 = (self.global_position - sourcePosition).normalized()
	self.velocity.x = damageDirection.x * 750
	self.velocity.y = damageDirection.y * 750
		
