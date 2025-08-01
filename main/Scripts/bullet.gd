class_name BulletProjectile
extends Area2D

var damage = 10
var knockback = 15
var travel_vector
var speed: int
var has_hit: Array[Enemy] = []

var data : Bullet 

func _process(delta: float) -> void:
    position += travel_vector * speed * delta

func shoot(player : Player) -> void:
    data.shoot(player)

func flying() -> void:
    data.flying()

func hit(target : Enemy) -> void:
    if target not in has_hit:
        target.take_damage(damage)
        target.process_knockback(knockback, travel_vector)
        has_hit.append(target)
        data.hit(target)
        if not data.piercing:
            queue_free()

func _on_area_entered(area: Area2D) -> void:
    if area.collision_layer == 1:
        # Colliding with Enemy!
        var enemy : Enemy = area.get_parent()
        hit(enemy)
