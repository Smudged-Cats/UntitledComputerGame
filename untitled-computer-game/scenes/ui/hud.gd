extends CanvasLayer
class_name Hud

@onready
var healthBar: TextureProgressBar = self.get_node("PlayerStatus").get_node("HealthBar")

@onready
var staminaBar: TextureProgressBar = self.get_node("PlayerStatus").get_node("StaminaBar")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerStatus/AmmoCount.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$PlayerStatus/AmmoCount.text = 
	pass


func _on_character_health_changed(newHealth: int) -> void:
	self.healthBar.value = newHealth
	
func _on_character_stamina_changed(newStamina: int) -> void:
	self.staminaBar.value = newStamina
