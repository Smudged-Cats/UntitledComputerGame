extends Node2D
class_name Enemy

@onready var hitboxScene = preload("res://scenes/radialHitbox.tscn")

@onready var lootScene = preload("res://scenes/weapons/droppedItem.tscn")

var _character: Character
var currentTarget: Character# = Player.instance._character
var _weapon: WeaponController

var t = 0

func _ready() -> void:
	print(get_node("Character").maxHealth)
	var modelRoot = get_node("Character").get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot")
	if Player.instance.playerLevel <= 1:
		modelRoot.get_node("RamEnemy").visible = false
		modelRoot.get_node("FanEnemy").visible = true
		modelRoot.get_node("FireEnemy").visible = false
	if Player.instance.playerLevel == 2:
		modelRoot.get_node("RamEnemy").visible = false
		modelRoot.get_node("FanEnemy").visible = false
		modelRoot.get_node("FireEnemy").visible = true
		get_node("Character").maxHealth = 200
	if Player.instance.playerLevel == 3:
		modelRoot.get_node("RamEnemy").visible = true
		modelRoot.get_node("FanEnemy").visible = false
		modelRoot.get_node("FireEnemy").visible = false
		get_node("Character").maxHealth = 500

	_character = get_node("Character")
	_character.characterName = "Enemy"
	_character.melee.baseMelee = MeleeStats.new(50,0.3, -1)
	_weapon = _character.weapon
	_weapon.holder = _character.characterName
	
	if Player.instance.playerLevel == 2:
		_weapon.setWeapon(DroppedItem.new().ranTypeOfGun("flamethrower2"))
	else:
		_weapon.setWeapon(DroppedItem.new().ranTypeOfGun("smg"))
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
	t+= delta
	if Player.instance.playerLevel <= 1:
		get_node("Character").get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").get_node("FanEnemy").rotate_y(10*delta)
	if Player.instance.playerLevel == 2:
		get_node("Character").get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").get_node("FireEnemy").global_position.z = sin(t)
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
		var difference = self.currentTarget.global_position - _character.global_position
		var threatDirection = (difference).normalized()
		var threatDirectionToIso = Vector2(threatDirection.x, clamp(threatDirection.y, -0.5, 0.5))
		if difference.length() <= 5:
			_character.melee.attack()
		if (difference.length() > 200 and difference.length() < 750) and Player.instance.playerLevel > 1:
			if Player.instance.playerLevel == 2:
				_weapon.shoot(threatDirection,_character.global_position, 2)
			if Player.instance.playerLevel == 3:
				_weapon.shoot(threatDirection,_character.global_position, 0)
		
		if (difference.length() < 750):
			_character.set_move_dir(threatDirectionToIso)
			_character.look_in_direction(threatDirection, delta)
		
	else:
		_character.set_move_dir(Vector2.ZERO)

func get_character() -> Character:
	return _character

func registerHit() -> void:
	self._character.velocity = Vector2.ZERO
	
