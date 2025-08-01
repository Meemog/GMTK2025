class_name Enemy
extends RigidBody2D

var player: Node
var speed
var hitpoints = 30
var damage : float = 1.0

func _ready() -> void:
    $Sprite.play()

func _process(delta: float) -> void:
    var vector_to_player = (player.position - position).normalized()

    position += vector_to_player * speed * delta
    
func take_damage(damage : float) -> void:
    hitpoints -= damage
    if hitpoints <= 0:
        die()
    print("Speed: "+str(speed))

func deal_damage(target : Player) -> void:
    target.take_damage(damage)
    die()

func die() -> void:
    Events.enemy_died.emit()
    queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
    
    if area.collision_layer == 8:
        # Collision with player
        print("Colliding with Player!!")
        var player : Player = area
        deal_damage(player)
    
    if area.collision_layer == 16:
        # Collision with bullet
        print("Colliding with Bullet!!")
        var bullet : BulletProjectile = area
        take_damage(bullet.damage)
