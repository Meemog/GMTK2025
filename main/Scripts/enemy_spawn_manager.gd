class_name EnemySpawnManager
extends Node2D

@export var player : Player
var group_size : int = 3
var group_variants : int = 1

var time_between_groups : float = 3.0
var time_between_groups_variant : float = 2.0

var spawn_distance : float = 2000.0
var group_seperation_distance : float = 500.0
var enemy_scene : PackedScene = preload("res://Scenes/enemy.tscn")

var number_of_enemies : int = 0
var enemies_remaining : int = 0
var enemy_speed : int = 200

func _ready() -> void:
    Events.new_round_started.connect(summon_wave)
    Events.enemy_died.connect(_on_enemy_died)
    Events.player_health_updated.connect(_on_player_health_updated)

func reset() -> void:
    remove_all_enemies()

func summon_wave(round_num : int) -> void:
    number_of_enemies = round_num + 2
    while number_of_enemies > 0:
        var new_group_size = group_size + randi_range(group_variants*-1, group_variants)
        summon_group(new_group_size)
        number_of_enemies -= new_group_size
        enemies_remaining += new_group_size

func summon_group(group_size : int) -> void:
    var group_summon_point : Vector2 = get_random_point_from_start(player.global_position, spawn_distance)
    for i in range(group_size):
        var enemy_summon_point : Vector2 = get_random_point_from_start(group_summon_point, group_seperation_distance)
        var new_enemy : Enemy = enemy_scene.instantiate()
        new_enemy.position = enemy_summon_point
        new_enemy.player = player
        new_enemy.speed = enemy_speed
        add_child(new_enemy)

func get_random_point_from_start(start_point : Vector2, distance : float) -> Vector2:
    var new_point = start_point
    var random_theta : float = randf_range(0, 360)
    new_point.x += cos(random_theta) * distance
    new_point.y += sin(random_theta) * distance
    return new_point
    
func remove_all_enemies() -> void:
    for child in get_children():
        if child is Enemy:
            child.queue_free()
    enemies_remaining = 0

func _on_enemy_died() -> void:
    enemies_remaining -= 1
    if enemies_remaining <= 0:
        Events.round_ended.emit()
        
func _on_player_health_updated(player_health : int) -> void:
    for child in get_children():
        if child is Enemy:
            var knockback_direction = (player.global_position - child.global_position)
            print("Trying to knockback!!!")
            child.process_knockback(-30.0, knockback_direction.normalized())
    
