extends CanvasLayer

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
