class_name FireEffect
extends StatusEffect
    
var fire_damage : float = 1
    
func effect_over_time(target : Node2D) -> void:
    if target is Enemy:
        target.take_damage(fire_damage)
