extends Bullet

func hit(target : Node2D) -> void:
    if target is Enemy:
        for child in target.get_children():
            if child is StatusEffectNode:
                if child.data is IceEffect:
                        target.take_damage(30.0)
                        Events.screen_shake_requested.emit(8, 0.2)
