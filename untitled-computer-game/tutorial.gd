extends CanvasLayer

static var tutorialMessageScene = preload("res://tutorial_message.tscn")

var click = false
var currentMessage = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Starting tutorial")
	await get_tree().create_timer(1).timeout
	currentMessage = add_message("Welcome to Untitled Computer Game!")
	
	await wait_until_message_is_null()
		
	currentMessage = add_message("what are you")

# Wait until message is removed
func wait_until_message_is_null():
	while (currentMessage != null):
		await get_tree().create_timer(0.25).timeout

func add_message(newMsg: String) -> TutorialMessage:
	var msgScene = tutorialMessageScene.instantiate()
	msgScene.message = newMsg
	$Control.add_child(msgScene)
	print(msgScene.message)
	return msgScene
