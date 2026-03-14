extends Node2D
class_name Enemy

@onready var hitboxScene = preload("res://scenes/radialHitbox.tscn")

var entities: Node

var _character: Character
var currentTarget: Character


func _ready() -> void:
	_character = get_node("Character")
	entities = get_parent()

func _physics_process(delta: float) -> void:
	if !is_instance_valid(_character): return
	chase_enemy()

func _process(delta: float) -> void:
	var health = _character.health
	$Character/HealthBar.value = health
	if health <= 0:
		die()

func die() -> void:
	queue_free()

func chase_enemy() -> void:
	if is_instance_valid(currentTarget):
		var difference = self.currentTarget.global_position - _character.global_position
		var threatDirection = (difference).normalized()
		var threatDirectionToIso = Vector2(threatDirection.x, clamp(threatDirection.y, -0.5, 0.5))
		if difference.length() <= 5:
			create_hitbox()
		_character.set_move_dir(threatDirectionToIso)
		_character.look_in_direction(threatDirection)
	else:
		_character.set_move_dir(Vector2.ZERO)
	

# Check for enemies every x second(s)
func _on_check_for_threats_timeout() -> void:
	var player_nodes = get_tree().get_nodes_in_group("players")
	
	for entity in player_nodes:
		if entity is Player:
			var entityCharacter = entity.get_character()
			if !is_instance_valid(entityCharacter) or entityCharacter.get_health() == 0: continue
			self.currentTarget = entityCharacter

func get_character() -> Character:
	return _character

func create_hitbox() -> void:
	var newHitbox = hitboxScene.instantiate();
	newHitbox.set_attacker(_character)
	newHitbox.global_position = self._character.position
	add_child(newHitbox)

func registerHit() -> void:
	self._character.velocity = Vector2.ZERO
