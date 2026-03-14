extends Label

var damage: int = 0:
	set(value):
		self.text = str(value)

var isDamage: bool = true
var fadeout: bool = false

var v: Vector2 = Vector2(0, -200)

func _ready() -> void:
	pass
	#v.x = randi_range(-50, 50)
	
	# TODO: if not isDamage, set tint color to green to indicate health or something (self modulate)

func _process(delta: float) -> void:
	
	self.global_position += v * delta
	
	if not fadeout:
		# slow down the number
		self.v = self.v.lerp(Vector2.ZERO, 5 * delta)
	else:
		# fade out the number, then remove
		self.self_modulate.a -= 5 * delta
		if self.self_modulate.a <= 0:
			queue_free()


func _on_timer_timeout() -> void:
	fadeout = true
