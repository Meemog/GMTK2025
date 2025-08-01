extends Control

signal play_btn_clicked()

@onready var play_button = $PlayButton

func _ready() -> void:
    play_button.pressed.connect(_on_play_button_pressed)

func _on_play_button_pressed():
    play_btn_clicked.emit()
