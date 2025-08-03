extends Bullet

func shoot(player : Player) -> void:
    player.current_invincibility_time = 1.2
    player.knockback(recoil)
