class_name UpdateChamberOverlay
extends Control

var is_visable : bool = true
var tween : Tween

var fade_seconds : float = 0.2

func _ready() -> void:
	Events.chamber_update_completed.connect(_on_chamber_update_completed)

func _process(delta: float) -> void:
	pass

func hide_overlay() -> void:
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
	tween.tween_callback(hide)

#func _on_hide_tooltip_requested() -> void:
	#is_visable = false
	#if tween:
		#tween.kill()
	#
	#get_tree().create_timer(fade_seconds, false).timeout.connect(hide_animation)
#
#func hide_animation() -> void:
	#if not is_visable:
		#tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		#tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
		#tween.tween_callback(hide)

func _on_chamber_update_completed() -> void:
	hide_overlay()
