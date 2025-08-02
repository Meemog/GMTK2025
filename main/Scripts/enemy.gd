class_name Enemy
extends RigidBody2D

@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer

var player: Node
var speed
var hitpoints = 30
var damage : int = 1
var vector_to_player: Vector2 = Vector2.ONE

func _ready() -> void:
    $Sprite.play()
    $ProgressBar.hide()
    $ProgressBar.max_value = hitpoints
    $ProgressBar.value = hitpoints

func _process(delta: float) -> void:
    vector_to_player = (player.position - position).normalized()

    position += vector_to_player * speed * delta
    position += linear_velocity
    
func take_damage(damage : float) -> void:
    if damage > 0:
        $ProgressBar.show()
        hitpoints -= damage
        $ProgressBar.value = hitpoints
        hit_flash_animation_player.play("hit_flash")
        if hitpoints <= 0:
            await get_tree().create_timer(0.2).timeout
            Events.screen_shake_requested.emit(5, 0.2)
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
        if player.linear_velocity.length() < 10:
            deal_damage(player)
        else:
            take_damage(player.collision_damage)
            process_knockback(80, vector_to_player.rotated(PI))
