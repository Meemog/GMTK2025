class_name BulletToolTip
extends Node2D

@onready var panel : PanelContainer = $PanelContainer

@export var fade_seconds : float = 0.2

var tween : Tween
var is_visable : bool = false

func _ready() -> void:
	Events.tooltip_requested.connect(_on_tooltip_requested)
	Events.hide_tooltop_requested.connect(_on_hide_tooltip_requested)
	modulate = Color.TRANSPARENT
	hide()

func _process(delta: float) -> void:
	pass

func _on_tooltip_requested() -> void:
	is_visable = true
	if tween:
		tween.kill()
	
	#global_position = get_global_mouse_position()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, fade_seconds)

func _on_hide_tooltip_requested() -> void:
	is_visable = false
	if tween:
		tween.kill()
	
	get_tree().create_timer(fade_seconds, false).timeout.connect(hide_animation)

func hide_animation() -> void:
	if not is_visable:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
		tween.tween_callback(hide)
