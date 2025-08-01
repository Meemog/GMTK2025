class_name BulletProjectile
extends Area2D

var damage = 10
var knockback = 1
var travel_vector
var speed: int

var data : Bullet 

func _process(delta: float) -> void:
    position += travel_vector * speed * delta

func shoot(player : Player) -> void:
    pass

func flying() -> void:
    pass

func hit(target : Node2D) -> void:
    data.hit(target)

func _on_area_entered(area: Area2D) -> void:
    if area.collision_layer == 1:
        # Colliding with Enemy!
        var enemy : Enemy = area.get_parent()
        hit(enemy)
