extends CanvasLayer

@onready var spectatorScene = preload("res://scenes/controllers/spectator.tscn")

var tFade: float = 0
var fading = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if fading:
		$DeathScreen/Tint.color = $DeathScreen/Tint.color.lerp(Color.BLACK, delta)


func _on_fade_timer_timeout() -> void:
	fading = true


func _on_texture_button_pressed() -> void:
	get_tree().reload_current_scene()
	


func _on_spectate_button_pressed() -> void:
	var newSpectator = spectatorScene.instantiate()
	get_tree().get_root().get_node("Node2D").add_child(newSpectator)
	newSpectator.make_current()
	queue_free()
