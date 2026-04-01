extends Node2D
class_name Enemy

@onready var hitboxScene = preload("res://scenes/radialHitbox.tscn")

@onready var lootScene = preload("res://scenes/weapons/droppedItem.tscn")

var _character: Character
var currentTarget: Character# = Player.instance._character
var _weapon: WeaponController

func _ready() -> void:
	_character = get_node("Character")
	_character.characterName = "Enemy"
	_character.melee.baseMelee = MeleeStats.new(50,0.3, -1)
	_weapon = _character.weapon
	_weapon.holder = _character.characterName
	
	_weapon.setWeapon(DroppedItem.new().ranGun())
	_weapon.weaponMuls.projectileStats.stats["damage"] -= 0.6
	_weapon.weaponMuls.projectileStats.stats["speed"] -= 0.3
	_weapon.weaponMuls.stats["ammo"] += 50
	
	if (_weapon.baseWeapon.stats["fireRate"] >= 1):
		_weapon.weaponMuls.stats["fireRate"] -= 0.4
	
	z_index = 1
	
	if Player.instance:
		currentTarget = Player.instance._character

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
		
	queue_free.call_deferred()

func chase_enemy(delta: float = 1) -> void:
	
	if is_instance_valid(currentTarget):
		var difference = self.currentTarget.global_position - self.global_position
		var threatDirection = (difference).normalized()
		var threatDirectionToIso = Vector2(threatDirection.x, clamp(threatDirection.y, -0.5, 0.5))
		if (difference.length() < 200):
			_character.set_move_dir(threatDirectionToIso)
			_character.look_in_direction(threatDirection, delta)
			if difference.length() <= 5:
				_character.melee.attack()
		if (difference.length() > 200 and difference.length() < 500):
			_weapon.shoot(threatDirection,_character.global_position, -1)
			_character.set_move_dir(threatDirectionToIso)
			_character.look_in_direction(threatDirection, delta)
		
	else:
		_character.set_move_dir(Vector2.ZERO)
	


func get_character() -> Character:
	return _character

func registerHit() -> void:
	self._character.velocity = Vector2.ZERO
