class_name FireEffect
extends StatusEffect
    
var fire_damage : float = 1

func apply_effect(target : Node2D) -> void:
    print("Fire Here!!!")

func effect_over_time(target : Node2D) -> void:
    if target is Enemy:
        print("Enemy Burning!!!")
        target.take_damage(fire_damage)
