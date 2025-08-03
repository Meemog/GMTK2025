extends Bullet

func hit(target : Node2D) -> void:
    var random_angle : float = randf_range(-(2*PI), (2*PI))
    bullet_projectile.travel_vector = Vector2((bullet_projectile.travel_vector.x * cos(random_angle)) - (bullet_projectile.travel_vector.y * sin(random_angle)),
                                            (bullet_projectile.travel_vector.x * sin(random_angle)) + (bullet_projectile.travel_vector.y * cos(random_angle)))
