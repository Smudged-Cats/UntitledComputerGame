extends CanvasLayer

static var tutorialMessageScene = preload("res://tutorial_message.tscn")

var click = false
var currentMessage: TutorialMessage = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Starting tutorial")
	await get_tree().create_timer(1).timeout
	
	currentMessage = add_message("Welcome to Untitled Computer Game!", true)
	await wait_until_message_is_null()
	
	currentMessage = add_message("Move around using the W A S D, or arrow keys.", true)
	await wait_until_message_is_null()
	
	currentMessage = add_message("Pick up a weapon by pressing [E] near it")
	await Player.instance.picked_up_item
	
	currentMessage = add_message("You can switch between weapons in your inventory by using the number keys", true)
	await wait_until_message_is_null()

	currentMessage = add_message("You can also drop a weapon whenever by pressing [Q]", true)
	await wait_until_message_is_null()
	
	currentMessage = add_message("Modifiers (folders) apply permanent boosts to your stats and can be dropped by pressing [P] in the reverse order that you pick them up.", true)
	await wait_until_message_is_null()
	
	currentMessage = add_message("When holding a melee weapon, hold left click to charge an attack", true)
	await wait_until_message_is_null()
	
	currentMessage = add_message("Release to perform the attack. The longer you charge means the stronger the attack", true)
	await wait_until_message_is_null()
	
	currentMessage = add_message("When holding a ranged weapon, right click to shoot in the direction of your mouse", true)
	await wait_until_message_is_null()
	
	currentMessage = add_message("On every map, can be found a pink USB stick, press [E] to pick it up", true)
	await Player.instance.picked_up_item
	
	currentMessage = add_message("At the center of the floor is a USB port, press [E] while hold the USB stick to plug it in", true)
	await wait_until_message_is_null()
	
	currentMessage = add_message("Plug in the USB stick, and survive until the timer runs out to complete the level!", true)
	await wait_until_message_is_null()

# Wait until message is removed
func wait_until_message_is_null():
	while (currentMessage != null):
		await get_tree().create_timer(0.25).timeout

func add_message(newMsg: String, canSkip: bool = false) -> TutorialMessage:
	
	if currentMessage:
		currentMessage.remove_message()
	
	var msgScene = tutorialMessageScene.instantiate()
	msgScene.canSkip = canSkip
	msgScene.message = newMsg
	$Control.add_child(msgScene)
	print(msgScene.message)
	return msgScene
