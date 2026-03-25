extends CanvasLayer

static var tutorialMessageScene = preload("res://tutorial_message.tscn")

var click = false
var currentMessage = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Starting tutorial")
	currentMessage = add_message("Welcome to Untitled Computer Game!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_message(newMsg: String) -> TutorialMessage:
	var msgScene = tutorialMessageScene.instantiate()
	$Control.add_child(msgScene)
	msgScene.message = newMsg
	print(msgScene.message)
	return msgScene
