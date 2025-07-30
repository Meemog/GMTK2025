class_name BulletUI
extends Control

@onready var drop_point_detector : Area2D = $DropPointDetector

var hovered : bool = false
var dragging : bool = false
var loaded : bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	
	if dragging:
		global_position = get_global_mouse_position() - pivot_offset

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false

func _on_gui_input(event: InputEvent) -> void:
	if not hovered:
		return
	
	if not dragging:
		if event.is_action_pressed("left_mouse"):
			pivot_offset = get_global_mouse_position() - global_position
			dragging = true
	elif dragging:
		var released = event.is_action_released("left_mouse")
		
		if released:
			pivot_offset = Vector2.ZERO
			dragging = false

func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
