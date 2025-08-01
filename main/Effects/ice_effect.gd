class_name IceEffect
extends StatusEffect

func apply_effect(target : Node2D) -> void:
    if target is Enemy:
        target.speed = target.speed * 0.2
        print(target.speed)

func remove_effect(target : Node2D) -> void:
    if target is Enemy:
        target.speed = target.speed / 0.2
