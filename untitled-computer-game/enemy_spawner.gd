extends Node2D

@onready var enemyScene = preload("res://scenes/controllers/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Simple loop to keep spawning enemies
	while true:
		await get_tree().create_timer(1).timeout
		var newEnemy = enemyScene.instantiate()
		get_tree().get_root().get_node("Node2D").get_node("Entities").add_child(newEnemy)
		newEnemy.global_position = self.global_position
