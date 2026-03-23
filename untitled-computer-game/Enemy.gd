extends Node2D
class_name Enemy

@onready var hitboxScene = preload("res://scenes/radialHitbox.tscn")

@onready var lootScene = preload("res://scenes/weapons/droppedItem.tscn")

var _character: Character
var currentTarget: Character = Player.instance._character

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
	chanceOfLoot = 1
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
		if (difference.length() < 400):
			var threatDirection = (difference).normalized()
			var threatDirectionToIso = Vector2(threatDirection.x, clamp(threatDirection.y, -0.5, 0.5))
			if difference.length() <= 5:
				_character.melee.attack()
			_character.set_move_dir(threatDirectionToIso)
			_character.look_in_direction(threatDirection, delta)
	else:
		_character.set_move_dir(Vector2.ZERO)
	


func get_character() -> Character:
	return _character

func registerHit() -> void:
	self._character.velocity = Vector2.ZERO
