extends CanvasLayer

func _ready() -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/testMap.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
