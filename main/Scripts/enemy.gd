class_name Enemy
extends RigidBody2D

var player: Node
var speed
var hitpoints = 30
var damage : int = 1

func _ready() -> void:
    $Sprite.play()

func _process(delta: float) -> void:
    var vector_to_player = (player.position - position).normalized()

    position += vector_to_player * speed * delta
    position += linear_velocity
    
func take_damage(damage : float) -> void:
    if damage > 0:
        hitpoints -= damage
        if hitpoints <= 0:
            die()

func process_knockback(knockback : float, direction: Vector2) -> void:
    linear_velocity += knockback * direction
    print("Knocked back: " + str(linear_velocity))

func deal_damage(target : Player) -> void:
    target.take_damage(damage)
    die()

func die() -> void:
    Events.enemy_died.emit()
    queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
    
    if area.collision_layer == 8:
        # Collision with player
        var player : Player = area.get_parent()
        deal_damage(player)
