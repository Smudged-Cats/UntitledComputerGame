class_name TutorialMessage
extends Label



# Animation variables
var easing_in = true
var tEaseIn = 0
static var curve = preload("res://resources/message_popup_curve.tres") # asset reuse

# Flashing variables
var text_alpha = 0 # The desired value we want the alpha channel of the prompt to be
var flashing = true
var flash_direction = 1

var message = "":
	set = on_message_set # Call this function to set the message

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale.x = 0
	scale.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Listen for input
	if Input.is_action_just_pressed("next message"):
		remove_message()
	
	# Ease in
	if easing_in:
		tEaseIn += 2*delta
		scale.x = curve.sample(tEaseIn)
		scale.y = curve.sample(tEaseIn)
		if tEaseIn >= curve.max_domain:
			easing_in = false

	# Flash the "next message" prompt
	if flashing:		
		text_alpha += flash_direction*delta
		if text_alpha <= 0:
			flash_direction = 1
		elif text_alpha >= 1:
			flash_direction = -1
		$Prompt.self_modulate.a = text_alpha

func remove_message() -> void:
	queue_free()

# TODO: Maybe some animations here would be cool
func on_message_set(newMsg) -> void:
	text = newMsg
