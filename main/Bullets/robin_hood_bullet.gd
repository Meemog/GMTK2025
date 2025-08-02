extends Bullet

func shoot(player : Player) -> void:
    for i in range(3):
        var idx : int = (player.bullet_pointer+1+i) % 6
        player.bullet_temp_bonuses[idx]["piercing"] = true
