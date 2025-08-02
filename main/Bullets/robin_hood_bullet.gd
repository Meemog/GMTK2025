extends Bullet

func shoot(player : Player) -> void:
    for i in range(3):
        var idx : int = (player.bullet_pointer+1+i) % 6
        var temp_bonuses : Dictionary = {}
        temp_bonuses["piercing"] = true
        temp_bonuses["damage"] = 0.6
        temp_bonuses["range"] = 1.4
        player.bullet_temp_bonuses[idx].append(temp_bonuses)
        #player.bullet_temp_bonuses[idx]["piercing"] = true
        #player.bullet_temp_bonuses[idx]["damage"] = 0.6
        #player.bullet_temp_bonuses[idx]["range"] = 1.4
