extends Node2D
class_name Enemy

var entities: Node

var _character: Character
var currentTarget: Character

func _ready() -> void:
	_character = get_node("Character")
	entities = get_parent()

func _physics_process(delta: float) -> void:
	chase_enemy()

func chase_enemy() -> void:
	if is_instance_valid(_character) and is_instance_valid(currentTarget):
		var difference = self.currentTarget.global_position - _character.global_position
		var threatDirection = (difference).normalized()
		var threatDirectionToIso = Vector2(threatDirection.x, clamp(threatDirection.y, -0.5, 0.5))
		_character.set_move_dir(threatDirectionToIso)
	else:
		_character.set_move_dir(Vector2.ZERO)

# Check for enemies every x second(s)
func _on_check_for_threats_timeout() -> void:
	for entity in entities.get_children():
		if (entity is Player):
			var entityCharacter: Character = entity.get_character()
			if !is_instance_valid(entityCharacter) or entityCharacter.get_health() == 0: continue
			print("ENEMY DETECTED")
			self.currentTarget = entityCharacter
