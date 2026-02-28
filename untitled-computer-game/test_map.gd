extends Node2D

@onready var enemyScene = preload("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#print(Character.characterCount)
	#var newEnemy = enemyScene.instantiate()
	#get_node("Entities").add_child(newEnemy)
	#print(Character.characterCount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
