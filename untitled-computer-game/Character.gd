extends CharacterBody2D
class_name Character

@onready var hitboxScene = preload("res://scenes/radialHitbox.tscn")

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

var _dashWindup: float = 0.0
var _meleeWindup: float = 0.0
var _isWindingUpAttack: bool = false

var move_dir: Vector2 = Vector2.ZERO

#Created a cooldown for attacks
var attackCooldown: Cooldown = Cooldown.new(0.3)

func _ready() -> void:
	
	# Assign the character a new id
	self.id = newCharacterId
	newCharacterId += 1
	
	#Created a cooldown for attacks
	add_child(attackCooldown)
	
	# Set the position of the 3d model so that it doesn't interfere with other 3d models
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("Camera3D").global_position.x += self.id * 10
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").global_position.x += self.id * 10

func _physics_process(delta: float) -> void:
	stamina += 10 * delta
	var direction: Vector2 = move_dir
	
	if _isWindingUpAttack and _meleeWindup < 1:
			_meleeWindup += delta * 2

	if direction != Vector2.ZERO:
		self.velocity.x = move_toward(self.velocity.x, direction.x * speed, acceleration)
		self.velocity.y = move_toward(self.velocity.y, direction.y * speed, acceleration)
	else:
		self.velocity.x = move_toward(self.velocity.x, 0.0, deceleration)
		self.velocity.y = move_toward(self.velocity.y, 0.0, deceleration)

	move_and_slide()
	
	self.z_index = self.global_position.y

func look_in_direction(dir: Vector2) -> void:
	self.get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").rotation.y = 90 + -global_position.direction_to(dir + self.global_position).angle()

func set_move_dir(dir: Vector2) -> void:
	self.move_dir = dir

func get_health() -> int:
	return health

func start_attack_windup() -> void:
	if attackCooldown.timeLeft() == 0:
		_isWindingUpAttack = true
	
func release_attack_windup() -> void:
	_isWindingUpAttack = false
	if _meleeWindup > 0:
		attack()

func attack() -> void:
	if attackCooldown.timeLeft() == 0:
	
		var power = _meleeWindup
		_meleeWindup = 0
		
		var newHitbox = hitboxScene.instantiate();
		newHitbox.set_attacker(self)
		newHitbox.set_damage(50 * power)
		add_child(newHitbox)
		attackCooldown.startTimer()

func dash() -> void:
	var mouseDirection: Vector2 = (get_global_mouse_position() - self.global_position).normalized()
	if stamina >= 20:
		self.velocity.x = mouseDirection.x * (250 + _dashWindup)
		self.velocity.y = mouseDirection.y * (250 + _dashWindup)
		stamina -= 20


func takeDamage(sourcePosition: Vector2) -> void:
	var damageDirection: Vector2 = (self.global_position - sourcePosition).normalized()
	self.velocity.x = damageDirection.x * (500 + _dashWindup)
	self.velocity.y = damageDirection.y * (500 + _dashWindup)
