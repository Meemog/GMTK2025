extends Control

signal play_btn_clicked()

@onready var play_button = $PlayButton
@onready var chamber_icon: Sprite2D = $MarginContainer/ChamberIcon

func _ready() -> void:
    play_button.pressed.connect(_on_play_button_pressed)

func _process(delta: float) -> void:
    chamber_icon.rotation += 0.005

func _on_play_button_pressed():
    play_btn_clicked.emit()
