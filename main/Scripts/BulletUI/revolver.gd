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

func populate(player_bullets : Array[Bullet]) -> void:
    for i in range(len(chambers)):
        chambers[i].clear_chamber()
        var new_bullet = bullet_ui.instantiate()
        new_bullet.data = player_bullets[i]
        new_bullet.purchased = true
        add_child(new_bullet)
        chambers[i].insert_bullet(new_bullet)
        new_bullet.init()

func _on_new_bullet_inserted(chamber : Chamber, bullet : Bullet) -> void:
    for i in range(len(chambers)):
        if chambers[i].current_bullet:
            bullets[i] = chambers[i].current_bullet.data
        else:
            bullets[i] = null
