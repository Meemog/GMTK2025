extends Bullet

func shoot(player : Player) -> void:
    for i in range(2):
        var idx : int = (player.bullet_pointer+1+i) % 6
        var temp_bonuses : Dictionary = {}
        temp_bonuses["status_effect"] = [IceEffect.new(effect_duration, "ice_effect")]
        player.bullet_temp_bonuses[idx].append(temp_bonuses)

func hit(target : Node2D) -> void:
    var new_status_effect : StatusEffectNode = status_effect_node_scene.instantiate()
    new_status_effect.data = IceEffect.new(effect_duration, "ice_effect")
    target.add_child(new_status_effect)
