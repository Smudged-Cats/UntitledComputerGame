extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_message("Welcome to Untitled Computer Game!")
	wait(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# wait n seconds
func wait(n) -> void:
	await get_tree().create_timer(n).timeout

func display_message(message: string):
	
