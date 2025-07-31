extends RigidBody2D

var player: Node
var speed
var hitpoints = 30

func _ready() -> void:
    $Sprite.play()

func _process(delta: float) -> void:
    var vector_to_player = (player.position - position).normalized()

    position += vector_to_player * speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
    hitpoints -= area.damage
    if hitpoints <= 0:
        queue_free()
