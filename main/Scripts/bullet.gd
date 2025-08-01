class_name BulletProjectile
extends Area2D

var damage = 10
var knockback = 1
var travel_vector
var speed: int

func _process(delta: float) -> void:
    position += travel_vector * speed * delta
