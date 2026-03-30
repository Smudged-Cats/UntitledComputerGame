extends CanvasLayer

var nextLevel: Button
var mainMenu: Button

func _ready() -> void:
	nextLevel = $NextLevel
	mainMenu = $MainMenu


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu.tscn")
	

func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file("res://proc_gen_map.tscn")
