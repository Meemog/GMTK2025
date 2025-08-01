extends Bullet

func hit(target : Node2D) -> void:
    print("Ice Bullet Hit!")
    print("Target: "+str(target))
    var new_status_effect : StatusEffectNode = status_effect_node_scene.instantiate()
    new_status_effect.data = IceEffect.new(effect_duration, effect_particle)
    target.add_child(new_status_effect)
