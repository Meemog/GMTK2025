extends Bullet

func shoot(player : Player) -> void:
    var shoot_direction = bullet_projectile.travel_vector
    var shoot_directions = [Vector2((shoot_direction.x * cos(0.5235988)) - (shoot_direction.y * sin(0.5235988)),
                                    (shoot_direction.x * sin(0.5235988)) + (shoot_direction.y * cos(0.5235988))), 
                            Vector2((shoot_direction.x * cos(-0.5235988)) - (shoot_direction.y * sin(-0.5235988)),
                                    (shoot_direction.x * sin(-0.5235988)) + (shoot_direction.y * cos(-0.5235988)))]
    for i in range(len(shoot_directions)):
        var new_bullet_projectile : BulletProjectile = bullet_projectile.bullet_projectile_scene.instantiate()
        new_bullet_projectile.travel_vector = shoot_directions[i]
        new_bullet_projectile.global_position = bullet_projectile.global_position
        new_bullet_projectile.speed = speed
        new_bullet_projectile.damage = damage
        new_bullet_projectile.range = range
        new_bullet_projectile.knockback = knockback
        new_bullet_projectile.piercing = piercing
        new_bullet_projectile.rotation = player.gun_rotation
        new_bullet_projectile.data = self.duplicate()
        print(new_bullet_projectile)
        player.get_parent().add_child(new_bullet_projectile)
