class_name StatusEffect
extends RefCounted

var duration : float 
var particle : Texture

func _init(duration : float, particle : Texture) -> void:
    self.duration = duration
    self.particle = particle

func apply_effect(target : Node2D) -> void:
    pass

func remove_effect(target : Node2D) -> void:
    pass
