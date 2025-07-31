class_name BulletShop
extends Node2D

# What the shop needs to do:

# Choose three random bullets types
# Instantiate and position them correctly
# Set each new bullets "bought" status to false
# Once one bullet is clicked the other two vanish

@export var bullet_types : Array[Bullet]

var bullet_ui: PackedScene = preload("res://Scenes/BulletUI/bullet_ui.tscn")
var bullet_positions : Array[Vector2] = [Vector2(655, 160), Vector2(971, 160), Vector2(1328, 160)]

func _ready() -> void:
	refresh_shop()

func refresh_shop() -> void:
	var new_bullets = select_new_bullet_types()
	instantiate_new_bullets(new_bullets)

func select_new_bullet_types() -> Array[Bullet]:
	var i = randi() % len(bullet_types)
	var j = randi() % len(bullet_types)
	var k = randi() % len(bullet_types)
	
	return [bullet_types[i].duplicate(), bullet_types[j].duplicate(), bullet_types[k].duplicate()]

func instantiate_new_bullets(new_bullets : Array[Bullet]) -> void:
	for i in range(len(new_bullets)):
		var bullet_instance = bullet_ui.instantiate()
		bullet_instance.data = new_bullets[i]
		bullet_instance.position = bullet_positions[i]
		add_child(bullet_instance)
