extends CharacterBody2D
class_name Character

signal health_changed(newHealth: int)
signal stamina_changed(newstamina: int)


static var newCharacterId = 0
var id = 0

@export var characterName = "Unnamed Character"

@export var maxHealth = 100
@export var maxStamina = 100

@export var health: int = 100:
	set(value):
		if health != value:
			health = clamp(value, 0, maxHealth)
			# Emit the signal with the new value as an argument
			emit_signal("health_changed", health)

@export var stamina: float = 100:
	set(value):
		if stamina != value:
			stamina = clamp(value, 0, maxStamina)
			# Emit the signal with the new value as an argument
			emit_signal("stamina_changed", stamina)

@export var speed: float = 300.0
var acceleration: float = 25.0
var deceleration: float = 25.0

var dashWindup: float = 0.0

var move_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	
	# Assign the character a new id
	self.id = newCharacterId
	newCharacterId += 1
	
	# Set the position of the 3d model so that it doesn't interfere with other 3d models
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("Camera3D").global_position.x += self.id * 10
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").global_position.x += self.id * 10

func _physics_process(delta: float) -> void:
	self.stamina += 10 * delta
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

func dash() -> void:
	var mouseDirection: Vector2 = (get_global_mouse_position() - self.global_position).normalized()
	if self.stamina >= 20:
		self.velocity.x = mouseDirection.x * (500 + dashWindup)
		self.velocity.y = mouseDirection.y * (500 + dashWindup)
		self.stamina -= 20


func takeDamage(sourcePosition: Vector2) -> void:
	var damageDirection: Vector2 = (self.global_position - sourcePosition).normalized()
	self.velocity.x = damageDirection.x * (500 + dashWindup)
	self.velocity.y = damageDirection.y * (500 + dashWindup)
	
#CreateCooldown is an easier way to create a timer that
# acts like a cooldown between attacks
func createCooldown(seconds:float) -> Timer:
	var newTimer = Timer.new()
	newTimer.wait_time = seconds
	newTimer.stop()
	newTimer.one_shot = true
	add_child(newTimer)
	return newTimer
