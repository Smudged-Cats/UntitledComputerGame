extends Camera2D

var mouse_down = false
var mouse_origin = Vector2.ZERO

var camera_offset = Vector2.ZERO
var target_position = Vector2.ZERO
var target_zoom: float = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spectator move"):
		mouse_down = true
		mouse_origin = get_local_mouse_position()
	elif Input.is_action_just_released("spectator move"):
		mouse_down = false
		camera_offset = global_position
		
	if Input.is_action_just_pressed("spectator zoom in"):
		target_zoom = min(target_zoom + 0.1, 5)
	elif Input.is_action_just_pressed("spectator zoom out"):
		target_zoom = max(target_zoom - 0.1, 0.05)
		
	if mouse_down:
		target_position = camera_offset + mouse_origin - get_local_mouse_position()
	
		global_position = global_position.lerp(target_position, 20*delta)
	zoom.x = lerp(zoom.x, target_zoom, 20*delta)
	zoom.y = zoom.x
