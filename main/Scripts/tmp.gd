extends Node2D

@onready var update_chamber_overlay: UpdateChamberOverlay = $CanvasLayer/UpdateChamberOverlay

@export var enemy_scene: PackedScene
@export var enemy_speed = 8

var current_round : int = 1

func _ready() -> void:
    update_chamber_overlay.close_overlay()
    Events.new_round_started.emit(current_round)
    Events.round_ended.connect(_on_round_ended)
    Events.chamber_update_completed.connect(_on_chamber_update_completed)

func _on_round_ended() -> void:
    print("Round Ended!!!")
    update_chamber_overlay.open_overlay()

func _on_chamber_update_completed() -> void:
    current_round += 1
    Events.new_round_started.emit(current_round)
