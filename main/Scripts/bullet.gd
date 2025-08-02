class_name BulletProjectile
extends Area2D

var damage = 10
var knockback = 15
var range : float = 0.5
var flying_effect_cooldown : float = 0.3
var travel_vector
var speed: int
var piercing : bool = false
var additional_status_effect : Array[StatusEffect] = []
var has_hit: Array[Enemy] = []

var status_effect_node_scene : PackedScene = preload("res://Scenes/status_effect_node.tscn")

var flying_effect_counter : float = 0.0
var range_counter : float = 0.0
var data : Bullet 

func _process(delta: float) -> void:
    flying_effect_counter += delta
    range_counter += delta
    
    if range_counter >= range:
        queue_free()
    
    if flying_effect_counter >= flying_effect_cooldown:
        flying_effect_counter = 0.0
        data.flying()

    position += travel_vector * speed * delta

func shoot(player : Player) -> void:
    print("Trying to recoil!")
    Events.camera_recoil_requested.emit(5, travel_vector.normalized(), 0.08, 0.1)
    data.shoot(player)

func flying() -> void:
    data.flying()

func hit(target : Enemy) -> void:
    if target not in has_hit:
        Events.screen_shake_requested.emit(8.0, 0.2)
        target.take_damage(damage)
        target.process_knockback(knockback, travel_vector)
        has_hit.append(target)
        apply_additional_status_effects(target)
        data.hit(target)
        if not piercing:
            queue_free()

func apply_additional_status_effects(target : Enemy) -> void:
    if len(additional_status_effect) == 0:
        return
    
    for i in range(len(additional_status_effect)):
        var new_status_effect : StatusEffectNode = status_effect_node_scene.instantiate()
        new_status_effect.data = additional_status_effect[i]
        target.add_child(new_status_effect)

func _on_area_entered(area: Area2D) -> void:
    if area.collision_layer == 1:
        # Colliding with Enemy!
        var enemy : Enemy = area.get_parent()
        hit(enemy)
