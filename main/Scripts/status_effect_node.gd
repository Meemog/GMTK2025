class_name StatusEffectNode
extends Node2D

var data : StatusEffect = null

func _ready() -> void:
    start_effect(get_parent())
    
func start_effect(target : Node2D) -> void:
    data.apply_effect(target)
    await get_tree().create_timer(data.duration).timeout
    end_effect(target)

func end_effect(target : Node2D) -> void:
    "Effect Ended!"
    data.remove_effect(target)
    queue_free()
