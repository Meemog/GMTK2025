class_name BulletUI
extends Node2D

signal bullet_purchased(bullet_ui : BulletUI)

@onready var bullet_side_view_texture: Sprite2D = $BulletSideView
@onready var bullet_back_view_texture: Sprite2D = $BulletBackView
@onready var collision_shape_2d: CollisionShape2D = $ClickDragArea/CollisionShape2D

var dragging : bool = false
var return_position : Vector2
var chambers_hovering_over : Array[Chamber] = []
var chambered : bool = false
var chamber : Chamber = null
var showing_side_view : bool = true
var purchased : bool = false

var data : Bullet = null

var tooltip_timer : Timer = Timer.new()
var tooltip_wait_time : float = 1.2

func _ready() -> void:
	return_position = global_position
	collision_shape_2d.shape = collision_shape_2d.shape.duplicate()

func _physics_process(delta: float) -> void:
	if dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		global_position = lerp(global_position, return_position, 10 * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if dragging:
				z_index = 1
				var closest_new_chamber = get_closest_chamber()
				if closest_new_chamber:
					closest_new_chamber.insert_bullet(self)
				if chambered:
					switch_view(false)
			dragging = false

func get_closest_chamber() -> Chamber:
	if len(chambers_hovering_over) == 0:
		return null
	if len(chambers_hovering_over) == 1:
		return chambers_hovering_over[0]
	var closest : Area2D = chambers_hovering_over[0]
	for i in range(1, len(chambers_hovering_over), 1):
		if global_position.distance_to(chambers_hovering_over[i].global_position) < global_position.distance_to(closest.global_position):
			closest = chambers_hovering_over[i]
	chambers_hovering_over = []
	return closest

func switch_view(side_view : bool) -> void:
	showing_side_view = side_view
	if side_view:
		bullet_back_view_texture.visible = false
		bullet_side_view_texture.visible = true
		collision_shape_2d.shape.size = Vector2(112, 196)
	else:
		bullet_back_view_texture.visible = true
		bullet_side_view_texture.visible = false
		collision_shape_2d.shape.size = Vector2(112, 112)

func _on_click_drag_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("shoot"):
		if not purchased:
			bullet_purchased.emit(self)
		dragging = true
		z_index = 10
		if chambered:
			switch_view(true)

func _on_click_drag_area_area_entered(area: Area2D) -> void:
	if area.collision_layer == 2:
		chambers_hovering_over.append(area)

func _on_click_drag_area_area_exited(area: Area2D) -> void:
	if area.collision_layer == 2:
		chambers_hovering_over.erase(area)

func _on_click_drag_area_mouse_entered() -> void:
	Events.tooltip_requested.emit()

func _on_click_drag_area_mouse_exited() -> void:
	Events.hide_tooltop_requested.emit()
