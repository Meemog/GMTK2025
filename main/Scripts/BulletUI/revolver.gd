class_name Revolver
extends Node2D

var bullet_ui: PackedScene = preload("res://Scenes/BulletUI/bullet_ui.tscn")
@export var basic_bullet : Resource

var chambers : Array[Chamber] = []
var bullets : Array[Bullet] = [null, null, null, null, null, null]

func _ready() -> void:
	for child in get_children():
		if child is Chamber:
			chambers.append(child)
			child.new_bullet_inserted.connect(_on_new_bullet_inserted)
	populate()

func populate() -> void:
	for chamber in chambers:
		var new_bullet = bullet_ui.instantiate()
		new_bullet.data = basic_bullet.duplicate()
		new_bullet.purchased = true
		add_child(new_bullet)
		chamber.insert_bullet(new_bullet)
	print(bullets)

func _on_new_bullet_inserted(chamber : Chamber, bullet : Bullet) -> void:
	for i in range(len(chambers)):
		if chambers[i].current_bullet:
			bullets[i] = chambers[i].current_bullet.data
		else:
			bullets[i] = null
