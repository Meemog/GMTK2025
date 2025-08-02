class_name StatusEffectNode
extends Node2D

var data : StatusEffect = null
var tick_rate_counter : float = 0
var target : Node2D = null

func _ready() -> void:
    target = get_parent()
    start_effect(target)
    var particle_node : CPUParticles2D = get_node(data.particle)
    if particle_node:
        particle_node.emitting = true

func _process(delta: float) -> void:
    tick_rate_counter += delta
    if tick_rate_counter >= data.tick_rate:
        tick_rate_counter = 0
        effect_over_time(target)
    
func start_effect(target : Node2D) -> void:
    data.apply_effect(target)
    await get_tree().create_timer(data.duration).timeout
    end_effect(target)

func effect_over_time(target : Node2D) -> void:
    data.effect_over_time(target)

func end_effect(target : Node2D) -> void:
    "Effect Ended!"
    data.remove_effect(target)
    queue_free()
