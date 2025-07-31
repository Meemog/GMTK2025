class_name Bullet
extends Resource

@export_group("Bullet Attributes")
@export var name : String
@export var damage : float
@export var knockback : float
@export var speed : float
@export_multiline var description : String

@export_group("Bullet Visuals")
@export var side_view_texture : Texture
@export var back_view_texture : Texture
