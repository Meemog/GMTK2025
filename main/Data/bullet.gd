class_name Bullet
extends Resource

enum EFFECT_TYPE {ICE, FIRE, BLEED}

@export_group("Bullet Attributes")
@export var name : String
@export var damage : float
@export var knockback : float
@export var speed : float
@export_multiline var description : String

@export_group("Bullet Visuals")
@export var side_view_texture : Texture
@export var back_view_texture : Texture

@export_group("Bullet Effects")
@export var has_effect : bool = false
@export var effect_duration : float = 2.0
@export var effect_particle : Texture

var status_effect_node_scene : PackedScene = preload("res://Scenes/status_effect_node.tscn")

func shoot(player : Player) -> void:
    pass

func flying() -> void:
    pass

func hit(target : Node2D) -> void:
    pass
