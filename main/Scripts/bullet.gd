extends Area2D

@export var speed = 800
@export var relative_rotation = 0

func _process(delta: float) -> void:
    position.x += speed*delta
