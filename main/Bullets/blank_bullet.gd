extends Bullet

func shoot(player : Player) -> void:
    player.knockback(recoil)
