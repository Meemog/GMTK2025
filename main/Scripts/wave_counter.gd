extends Control

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

var tween : Tween
var fade_seconds : float = 0.2

var show_time : float = 4.0

func _ready() -> void:
    Events.new_round_started.connect(_on_new_round_started)
    hide()
    
func fade_in() -> void:
    if tween:
        tween.kill()
    
    #global_position = get_global_mouse_position()
    tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_callback(show)
    tween.tween_property(self, "modulate", Color.WHITE, fade_seconds)

func fade_out() -> void:
    if tween:
        tween.kill()
    
    tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
    tween.tween_callback(hide)

func _on_new_round_started(round_num : int) -> void:
    rich_text_label.text = "[wave]Wave "+str(round_num)
    fade_in()
    await get_tree().create_timer(show_time).timeout
    fade_out()
    
