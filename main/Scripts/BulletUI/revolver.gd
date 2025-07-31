class_name Revolver
extends Node2D

var chambers : Array[Chamber] = []

func _ready() -> void:
	for child in get_children():
		if child is Chamber:
			chambers.append(child)
			child.new_bullet_inserted.connect(_on_new_bullet_inserted)

func _on_new_bullet_inserted(bullet : BulletUI) -> void:
	print("New Bullet Inserted!")
