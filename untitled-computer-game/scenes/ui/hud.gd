extends CanvasLayer
class_name Hud

@onready
var healthBar: TextureProgressBar = self.get_node("PlayerStatus").get_node("HealthBar")

@onready
var staminaBar: TextureProgressBar = self.get_node("PlayerStatus").get_node("StaminaBar")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerStatus/AmmoCount.visible = false
	$PlayerInventory/GridContainer/Arrow1.visible = false
	$PlayerInventory/GridContainer/Arrow2.visible = false
	$PlayerInventory/GridContainer/Arrow3.visible = false
	$PlayerStatus/WeaponStats.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$PlayerStatus/AmmoCount.text = 
	pass
	match(Player.instance.playerLevel):
		1: $LevelLabel.text = "Lvl: 1"
		2: $LevelLabel.text = "Lvl: 2"
		3: $LevelLabel.text = "Lvl: 3"


func _on_character_health_changed(newHealth: int) -> void:
	self.healthBar.value = newHealth
	
func _on_character_stamina_changed(newStamina: int) -> void:
	self.staminaBar.value = newStamina
