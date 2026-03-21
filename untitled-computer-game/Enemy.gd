extends Node2D
class_name Enemy

@onready var hitboxScene = preload("res://scenes/radialHitbox.tscn")

@onready var lootScene = preload("res://scenes/weapons/droppedItem.tscn")

var _character: Character
var currentTarget: Character

func _ready() -> void:
	_character = get_node("Character")
	_character.melee.baseMelee = MeleeStats.new(50,0.3)
	z_index = 1

func _physics_process(delta: float) -> void:
	if !is_instance_valid(_character): return
	chase_enemy(delta)

func _process(delta: float) -> void:
	var health = _character.health
	$Character/HealthBar.value = health
	if health <= 0:
		die()

func die() -> void:
	var chanceOfLoot = randi_range(1,10)
	var weaponTypes = ["Weapon", "Melee", "Modifier"]
	if chanceOfLoot == 1:
		var newDroppedItem = lootScene.instantiate()
		newDroppedItem.setWeaponType(weaponTypes[randi_range(0,2)])
		newDroppedItem.position = _character.global_position
		get_parent().add_child(newDroppedItem)
		
	queue_free()

func chase_enemy(delta: float = 1) -> void:
	if is_instance_valid(currentTarget):
		var difference = self.currentTarget.global_position - _character.global_position
		var threatDirection = (difference).normalized()
		var threatDirectionToIso = Vector2(threatDirection.x, clamp(threatDirection.y, -0.5, 0.5))
		if difference.length() <= 5:
			_character.melee.attack()
		_character.set_move_dir(threatDirectionToIso)
		_character.look_in_direction(threatDirection, delta)
	else:
		_character.set_move_dir(Vector2.ZERO)
	

# Check for enemies every x second(s)
func _on_check_for_threats_timeout() -> void:
	var character_nodes = get_tree().get_nodes_in_group("characters")
	
	# Check every entity in the entity nodes
	for entity in character_nodes:
		if entity is Player:
			var entityCharacter = entity.get_character()
			if !is_instance_valid(entityCharacter) or entityCharacter.get_health() == 0: continue
			self.currentTarget = entityCharacter

func get_character() -> Character:
	return _character

func registerHit() -> void:
	self._character.velocity = Vector2.ZERO
