extends Camera2D

@export var subject: Node2D

const CAMERA_CHASE_SPEED: float = 3.0
const DEFAULT_ZOOM: float = 2.0

var pulseCurve = preload("res://resources/camera_pulse_curve.tres")

var _tPulse: float = pulseCurve.max_domain
var _pulse_factor: float = 0.25

func _ready() -> void:
	self.global_position = subject.global_position

# We don't update the camera position here, but we do it in the _physics_process loop in Player.
# However, we do update the camera effects here
func _process(delta: float) -> void:
	
	# Update the zoom
	var pulseValue = pulseCurve.sample(_tPulse) * _pulse_factor
	_tPulse = min(_tPulse + delta, pulseCurve.max_domain)
	self.zoom.x = DEFAULT_ZOOM + pulseValue
	self.zoom.y = DEFAULT_ZOOM + pulseValue
	

func update_camera_position(delta: float) -> void:
	if !is_instance_valid(self):
		return
	
	self.global_position = self.global_position.lerp(
		subject.global_position,
		CAMERA_CHASE_SPEED * delta
	)

# Set the playback head to t = 0 to play the effect
func pulse(factor: float) -> void:
	# play the pulse animation
	_pulse_factor = factor
	_tPulse = 0


func _on_character_damaged(damage: int) -> void:
	pulse(0.2)
