extends Control

var is_visable = false
var tween : Tween

var fade_seconds : float = 0.2

func _ready() -> void:
    Events.player_killed.connect(_on_player_killed)
    hide()

func _on_button_pressed() -> void:
    Events.game_restart_requested.emit()
    hide_overlay()
    
func hide_overlay() -> void:
    is_visable = false
    if tween:
        tween.kill()
    
    tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
    tween.tween_callback(hide)
    
func show_overlay() -> void:
    is_visable = true
    if tween:
        tween.kill()
    
    #global_position = get_global_mouse_position()
    tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_callback(show)
    tween.tween_property(self, "modulate", Color.WHITE, fade_seconds)

func _on_player_killed() -> void:
    show_overlay()
    
