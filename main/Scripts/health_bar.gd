extends Control

var current_health : int = 3
@onready var heart_container: VBoxContainer = $MarginContainer/HeartContainer

func _ready() -> void:
    Events.player_health_updated.connect(_on_player_health_updated)

func remove_heart() -> void:
    for child in heart_container.get_children():
        if child is TextureRect:
            child.queue_free()
            break

func _on_player_health_updated(health : int) -> void:
    current_health = health
    remove_heart()
    
