extends Bullet

func hit(target : Node2D) -> void:
    var new_status_effect : StatusEffectNode = status_effect_node_scene.instantiate()
    new_status_effect.data = FireEffect.new(effect_duration, "fire_effect")
    target.add_child(new_status_effect)
