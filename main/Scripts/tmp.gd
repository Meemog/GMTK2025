extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_speed = 200

func _ready() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.player = $Player
	enemy.speed = enemy_speed
	add_child(enemy)
