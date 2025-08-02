class_name StatusEffect
extends RefCounted

var duration : float 
var tick_rate : float = 0.2
var particle : String = "ice_effect"

func _init(duration : float, particle : String) -> void:
    self.duration = duration
    self.particle = particle

func apply_effect(target : Node2D) -> void:
    pass

func effect_over_time(target : Node2D) -> void:
    pass

func remove_effect(target : Node2D) -> void:
    pass
