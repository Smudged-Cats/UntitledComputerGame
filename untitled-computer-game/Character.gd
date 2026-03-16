extends CharacterBody2D
class_name Character

@onready var hitboxScene = preload("res://scenes/radialHitbox.tscn")
@onready var damageNumberScene = preload("res://scenes/ui/damageNumber.tscn")

signal health_changed(newHealth: int)
signal stamina_changed(newstamina: int)

signal damaged(damage: int)

static var newCharacterId = 0
var id = 0

@export var characterName = "Unnamed Character"

@export var maxHealth = 100
@export var maxStamina = 100

@export var health: int = 100:
	set(value):
		if health != value:
			var oldHealth = health
			health = clamp(value, 0, maxHealth)
			# Emit signals
			emit_signal("health_changed", health)
			if health - oldHealth < 0:
				emit_signal("damaged", health - oldHealth)

@export var stamina: float = 100:
	set(value):
		if stamina != value:
			stamina = clamp(value, 0, maxStamina)
			# Emit the signal with the new value as an argument
			emit_signal("stamina_changed", stamina)

@export var maxSpeed: float = 300.0
var acceleration: float = 25.0
var deceleration: float = 25.0

var dashWindup: float = 0.0
var meleeWindup: float = 0.0
var isWindingUpAttack: bool = false

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
	$SubViewportContainer/SubViewport/Camera3D.global_position.x += self.id * 10
	$SubViewportContainer/SubViewport/ModelRoot.global_position.x += self.id * 10

func _physics_process(delta: float) -> void:
	
	# update stamina
	stamina += 10 * delta
	
	var speed = maxSpeed
	if dashWindup > 0:
		speed = lerp(speed, speed/5, dashWindup)
	
	if isWindingUpAttack and meleeWindup < 1:
			meleeWindup = move_toward(meleeWindup, 1, delta * 2)
	$MeleeBar.value = meleeWindup

	if move_dir != Vector2.ZERO:
		self.velocity.x = move_toward(self.velocity.x, move_dir.x * speed, acceleration)
		self.velocity.y = move_toward(self.velocity.y, move_dir.y * speed, acceleration)
	else:
		self.velocity.x = move_toward(self.velocity.x, 0.0, deceleration)
		self.velocity.y = move_toward(self.velocity.y, 0.0, deceleration)

	move_and_slide()
	
	#self.z_index = self.global_position.y

func look_in_direction(dir: Vector2, delta: float = 1) -> void:
	$SubViewportContainer/SubViewport/ModelRoot.rotation.y = 90 + -global_position.direction_to(dir + self.global_position).angle()

func set_move_dir(dir: Vector2) -> void:
	self.move_dir = dir

func get_health() -> int:
	return health

func start_attack_windup() -> void:
	if attackCooldown.timeLeft() == 0:
		isWindingUpAttack = true
	
func release_attack_windup() -> void:
	isWindingUpAttack = false
	if meleeWindup > 0:
		attack()

func attack() -> void:
	if attackCooldown.timeLeft() == 0:
	
		var power = meleeWindup
		meleeWindup = 0
		stamina -= 10
		
		var newHitbox = hitboxScene.instantiate();
		newHitbox.set_attacker(self)
		newHitbox.set_damage(50 * power + 50)
		add_child(newHitbox)
		attackCooldown.startTimer()

func dash() -> void:
	var mouseDirection: Vector2 = (get_global_mouse_position() - self.global_position).normalized()
	if stamina >= 20:
		self.velocity.x = mouseDirection.x * (400 + dashWindup * 500)
		self.velocity.y = mouseDirection.y * (400 + dashWindup * 500)
		stamina -= 20


func takeDamage(damage: int, sourcePosition: Vector2, enemySpeed) -> void:
	
	health -= damage
	
	var damageDirection: Vector2 = (self.global_position - sourcePosition).normalized()
	self.velocity.x = damageDirection.x * (650 + enemySpeed)
	self.velocity.y = damageDirection.y * (650 + enemySpeed)
	
	var newNumberScene = damageNumberScene.instantiate()
	newNumberScene.damage = damage
	newNumberScene.global_position = global_position
	get_tree().get_root().add_child(newNumberScene)
